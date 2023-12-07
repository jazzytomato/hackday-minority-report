# Minority Report

Because [your code is a crime scene](https://www.adamtornhill.com/articles/crimescene/codeascrimescene.htm).

```sh
docker build -t minority-report . && \
docker run -it -p 8000:8000 \
  -v /Users/tomharatyk/projects/vw-to-ehr-integrations:/repo \
  minority-report \
  backend # folder to analyse 
```

Go to http://localhost:8000