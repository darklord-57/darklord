# Import libraries
import streamlit as st
import base64

# Custom CSS styling
def local_css(file_name):
    with open(file_name) as f:
        st.markdown(f'<style>{f.read()}</style>', unsafe_allow_html=True)

def remote_css(url):
    st.markdown(f'<link href="{url}" rel="stylesheet">', unsafe_allow_html=True)

# Adding custom CSS
local_css("style.css")
remote_css("https://fonts.googleapis.com/css?family=Roboto")

# Add a title to the app
st.markdown("""
    <div class="app-title">
        <h1>Social Media Influence</h1>
    </div>
""", unsafe_allow_html=True)
