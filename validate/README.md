Validate
========

`validate.pl` is used to check drug title.

Execute
-------
```bash
$ wget "http://data.fda.gov.tw/opendata/exportDataList.do?method=ExportData&InfoId=36&logType=1" -O 36.zip
$ unzip 36.zip
$ ls *.xml
36_1.xml
$ ./validate.pl 36_1.xml | tee data/20150324.tsv
```

Reference
---------
http://data.fda.gov.tw/frontsite/data/DataAction.do?method=doDetail&infoId=36
