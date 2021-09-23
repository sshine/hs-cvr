# cvr

https://data.virk.dk/datakatalog/erhvervsstyrelsen/system-til-system-adgang-til-cvr-data

```
jq '."cvr-v-20200115".mappings._doc.properties' mapping.json > Vrvirksomhed.json
jq '."cvr-d-20180927".mappings._doc.properties' mapping.json > Vrdeltagerperson.json
```
