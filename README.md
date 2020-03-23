# COVID-19_Data
Aggregate data call from Johns Hopkins github repository.

Data retrieved from: https://github.com/CSSEGISandData/COVID-19

Infection cases are cumulative by province/State. 

Data may either be retrieved by cloning or through and html call.

```{python}
url = "https://raw.githubusercontent.com/tykiww/COVID-19_Data/master/manual.R"
source(url) # data returned as df
```
