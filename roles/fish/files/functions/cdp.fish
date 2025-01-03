function cdp
    set pwd $PWD

    while test "$pwd" != "$HOME"
        if find "$pwd" -maxdepth 1 -type f -name "package.json" | grep -q .
            cd "$pwd"
            return
        else
            set pwd (dirname $pwd)
        end
    end

    echo "Nearest package.json not found"
end
