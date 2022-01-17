#!/usr/bin/env node
const fs = require("fs");
const os = require("os");
const { execSync } = require("child_process");

const OS_PLATFORM = os.platform();
const OS_RELEASE = os.release();

(async () => {
  const apps = JSON.parse(
    await fs.promises.readFile("apps.json", { encoding: "utf8" })
  );

  const packageType = {
    wsl: isWSL(),
    macos: isMacOS(),
    linux: isLinux(),
  };

  const allApps = Object.values(apps).flatMap((config) => {
    return filterAppsForConfig(config, packageType);
  });

  for (const app of allApps) {
    installApp(app);
  }
})();

function isWSL() {
  return /microsoft/i.test(OS_RELEASE) && /WSL/.test(OS_RELEASE);
}

function isMacOS() {
  return /darwin/.test(OS_PLATFORM);
}

function isLinux() {
  return /linux/.test(OS_PLATFORM);
}

function filterAppsForConfig(config, packageType) {
  let apps = config.apps;
  // filter out ignored packages
  Object.keys(packageType).forEach((type) => {
    if (config[type] && config[type].ignore) {
      if (typeof config[type].ignore === "boolean") {
        apps = [];
      } else {
        const ignoreList = new Set(config[type].ignore);
        apps = apps.filter((app) => !ignoreList.has(app));
      }
    }
  });

  return apps;
}

function installApp(appName) {
  const installer = {
    fzf: {
      macos: execSync("brew install fzf"),
      linux: execSync("sudo apt install fzf"),
    },

    fd: {
      macos: execSync("brew install fd"),
      linux: execSync(
        "sudo apt install fd-find && ln -s $(which fdfind) ~/.local/bin/fd"
      ),
    },

    ripgrep: {
      macos: execSync("brew install ripgrep"),
      linx: execSync("sudo apt install ripgrep"),
    },

    bat: {
      macos: execSync("brew install bat"),
      linux: execSync(
        "sudo apt install bat && ln -s $(which batcat) ~/.local/bin/bat"
      ),
    },

    delta: {
      macos: execSync("brew install git-delta"),
      linux: execSync("cargo install git-delta"),
    },
    tmux: {
      macos: execSync("brew install tmux"),
      linux: execSync("sudo apt install tmux")
    },
    neovim: {
      macos: execSync('brew install neovim'),
      linux: execSync('sudo apt install neovim')
    },
    docker: {
      macos: {

      }
    }
  };
  console.log(appName);
}
