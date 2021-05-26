# InfertDataProject

## Data understanding

The data collected  to develop the R Shiny application is the Infertility after Spontaneous and Induced Abortion dataset, or "infert" from R Studio dataset package. This dataset respond to an study of secondary infertility in woman, for more information see: http://www.floppybunny.org/robin/web/virtualclassroom/stats/statistics2/articles/cond_log_reg_trichopulos_1976.pdf  

The dataset have 8 features and 248 observations. For every patient, an attempt was made to find two healthy control subjects from the same hospital with matching for age, parity, and level of education. Two control subjects each were found for 83 of the index patients.


## Questions to anwers about the study

The app is expected to answer the following questions:

1. Wich women have much more induced abortions, those with secondary infertility (Case), or those that don't have secondary infertility (Control)?.

2. Wich women have given birth more times, those with fewer or more years of education?. 

3. How age or the number of pregnancies influence the probability of secondary infertility in women when spontaneous or induced abortions occur?.

The first two are answered by the exploratory analysis, the third with the prediction model.

## App instructions

The app is divided into two areas with reactive inputs and three tabs: **Exploratory Analysis**, **Prediction** and **Dataset**

- Use the **Reactive Inputs** to filter by age, years of education, number of previous pregnancy, and number of spontaneous or induced abort.

- On the **Exploratory Analysis** tab, see how the filters can be used to explore the information. See if there are any insights that you can come up with from the data.

- Switch to the **Dataset** tab to see how the filters control the data. Subset the data, and try downloading the CSV file.

- On the **Reset Fields** button refresh the data to its original size.

- Use the **Prediction** tab, to predict with a Simple linear regression model, the probability of secondary infertility when selecting the predictor and the color group from the reactive input. 

The source code is available on Github [here](https://duckduckgo.com).
