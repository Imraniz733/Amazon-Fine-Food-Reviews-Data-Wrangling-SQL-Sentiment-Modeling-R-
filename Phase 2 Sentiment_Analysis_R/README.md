# 📊 Phase 2: Sentiment Analysis (R)

This phase focuses on analyzing the sentiments expressed in the customer reviews. The goal is to understand how customers feel about the product/service and identify patterns in positive and negative feedback.

## 🔍 Objectives
- Exploratory data analysis (EDA).

- Feature Engineering.

- Perform word frequency analysis.

- Generate a Document-Term Matrix (DTM).

- Create a word cloud for visualization.

- Perform Sentiment Distribution.

- Visualizing Review Ratings

- Conduct sentiment scoring using lexicons.

- Analyze the correlation between sentiment scores and review length.


## 🧰 Tools & Packages Used
- tm – text mining and preprocessing

- tidyverse – data manipulation and visualization

- wordcloud – visualizing frequent words

- ggplot2 – plotting results

- dplyr – data wrangling

- knitr – R Markdown output


## 🧹 Data Preprocessing
- Removed punctuation, numbers, and stopwords

- Lowercased all text

- Applied stemming/lemmatization (if done)

- Created a clean corpus for analysis


## 📈 Key Analyses
- Length of Reviews: We used a bar plot to see unusual short or long reviews.

- Word Frequency & Word Cloud: Identified the most frequently used terms and visualized them.

- Sentiment Score Distribution: Used bar plots to show the spread of sentiment scores across reviews.

- Review Length Analysis: Examined how review length relates to rating and sentiment.

📁 Output
All plots and processed data were saved and exported in .Rds and .html format.

The final HTML report includes all visualizations, code, and interpretations.

📌 Notes
cache = TRUE and warning = FALSE were used to optimize R Markdown rendering.

Heavy computations like DTM and wordcloud were pre-run and cached.
