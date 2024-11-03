# HR Analytics Project: Building an Employee Experience and Retention Analysis System

## Overview

This project is a comprehensive journey to build an analytics system for understanding employee experience, retention, and performance across a company's workforce. The goal of this system is to provide actionable insights for HR teams on factors such as employee satisfaction, training impact, productivity, and recruitment success.

As someone new to Human Resource Management (HRM), I began this project with the intention of analyzing an existing dataset from Kaggle to understand key metrics and trends within HRM data. However, as I delved deeper, I realized that I wanted more control over the data structure and features to explore specific questions that are important for modern HR analytics. This led me to pivot from using a Kaggle dataset to generating my own synthetic data.

## Why Generate a Custom Dataset?

While Kaggle offers excellent datasets, I felt that creating my own would allow me to:

1. Tailor the dataset to focus on HR-related questions that are of particular interest, such as the impact of remote work, factors affecting retention, and drivers of client satisfaction.
2. Gain a deeper understanding of the data-generation process, including which variables and metrics are most relevant in an HR context.
3. Customize the dataset to include specific fields and structure that better align with the project's analytical goals.

Since I had no prior experience in HRM, I referred to the Kaggle dataset as a template to understand what information is typically included in HR data, such as employee demographics, performance metrics, and retention data. From there, I built my own dataset using Python, creating realistic data for employees, their departments, performance evaluations, and more.

## Project Goals

The primary objective of this project is to build a data-driven solution for HR teams to answer the following questions:

1. **What factors most influence employee retention across different departments?**
2. **Which performance metrics correlate most strongly with high client satisfaction in sales and customer-facing roles?**
3. **How does remote work status affect productivity and engagement across various roles and departments?**
4. **What is the impact of training hours, certifications, and mentoring on employee performance?**
5. **What are the key drivers of recruitment success in terms of time-to-fill, retention rate, and recruitment source?**

These questions align with broader HR goals to optimize recruitment, improve employee satisfaction, and enhance overall productivity.

### Big Picture Question:

6. **How can we design an optimal employee experience strategy that aligns retention, productivity, and client satisfaction with professional development and recruitment policies?**

## Project Workflow

The project is structured as a sequential journey, with each section covering a specific aspect of the analysis:

1. **Getting Started**: A general introduction to the project’s goals, datasets, and analysis approach.
2. **Data Generation**: Using Python to create a synthetic HR dataset based on insights from the Kaggle dataset, ensuring that all necessary fields and data points are included.
3. **Database Setup and Initial Data Import**: Setting up a PostgreSQL database and importing the generated data, establishing a solid foundation for efficient data analysis.
4. **Data Cleaning and Exploration**: Cleaning and standardizing data, then conducting exploratory data analysis to understand trends and outliers.
5. **Data Analysis and Visualizations**: Analyzing data and visualizing insights for each research question, using Python libraries such as Matplotlib, Seaborn, and Plotly.
6. **Building an Interactive Dashboard**: Aggregating visualizations into a dashboard for HR teams to explore insights interactively.
7. **Conclusion and Strategy Recommendations**: Summarizing findings and suggesting HR strategies based on data-driven insights.

## Technologies Used

- **Python** for data generation, analysis, and visualization.
- **PostgreSQL** as the database for storing and querying data.
- **Pandas**, **NumPy** for data manipulation.
- **SQLAlchemy** for database connection and data management.
- **Matplotlib**, **Seaborn**, and **Plotly** for data visualization.
- **Streamlit** or **Dash** (optional) for building an interactive dashboard. -> If you want to, you can do this part, I'll maybe build this after long time, hang around!

## How to Get Started [OR] Refer to Folder *"Integration Setup of..."*

1. **Clone the repository** and install the required dependencies listed in `requirements.txt`.
2. **Run the data generation script** (see `fake_data_generation_code.ipynb`) to create a synthetic HR dataset.
3. **Import the data** into PostgreSQL using the provided setup scripts.
4. **Follow along with each section** to build the analysis system, referring to the README and code documentation as needed.

## Insights Gained and Next Steps

Throughout this project, I learned the importance of understanding data structure, especially in HR analytics, and how critical it is to tailor datasets to specific business questions. By generating my own data, I gained a hands-on perspective of what goes into creating and managing a database, along with the complexities of analyzing HR metrics.

In future projects, I plan to apply these skills to real-world HR data, improving my approach based on what I learned here. This journey has been an invaluable experience in building foundational skills in data generation, database management, and data-driven decision-making.

---

Feel free to ask for clarifications or suggestions on this README.

### Files to Delete (if applicable)

*You can remove the initial Kaggle dataset file if included (since we created a custom dataset) to streamline YOUR {I'll leave them in the repo if you want to work on the kaggle dataset} repository.*
