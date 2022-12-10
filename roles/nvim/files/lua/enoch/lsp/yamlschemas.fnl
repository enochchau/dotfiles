(macro yamlschemas []
  (let [schemas ((. (require :schemastore) :json :schemas))]
    (accumulate [all {} _ schema (ipairs schemas)]
      (do
        (tset all schema.url schema.fileMatch)
        all))))

(yamlschemas)
