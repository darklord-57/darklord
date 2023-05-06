import streamlit as st
from intro import introduction_page
from user_input import input_page
from plots import plots_page
from conclusion import conclusion_page

def local_css(css_str):
    st.markdown(f'<style>{css_str}</style>', unsafe_allow_html=True)

def remote_css(url):
    st.markdown(f'<link href="{url}" rel="stylesheet">', unsafe_allow_html=True)

# Adding custom CSS
local_css("style.css")
remote_css("https://fonts.googleapis.com/css?family=Roboto")


# Store the current page in a dictionary
state = {"current_page": "Introduction"}

# Function to set the current page
def set_current_page(new_page):
    state["current_page"] = new_page

# navigation title
st.sidebar.title("Navigation")

# navigation buttons
if st.sidebar.button("Intro"):
    set_current_page("Intro")

if st.sidebar.button("Input"):
    set_current_page("Input")

if st.sidebar.button("Plots"):
    set_current_page("Plots")

if st.sidebar.button("Conclusion"):
    set_current_page("Conclusion")

# user's selection
if state["current_page"] == "Intro":
    introduction_page()
elif state["current_page"] == "Input":
    input_page()
elif state["current_page"] == "Plots":
    plots_page()
elif state["current_page"] == "Conclusion":
    conclusion_page()
