# Import libraries
import streamlit as st

# Custom CSS styling
def local_css(css_str):
    st.markdown(f'<style>{css_str}</style>', unsafe_allow_html=True)

def remote_css(url):
    st.markdown(f'<link href="{url}" rel="stylesheet">', unsafe_allow_html=True)

# Adding custom CSS
css_styles = """
body {
    font-family: 'Roboto', sans-serif;
}

.app-title {
    text-align: center;
    margin-bottom: 50px;
}

h1 {
    font-size: 48px;
    font-weight: bold;
    color: #4a4a4a;
}
"""

local_css(css_styles)
remote_css("https://fonts.googleapis.com/css?family=Roboto")

# Add a title to the app
st.markdown("""
    <div class="app-title">
        <h1>Social Media Influence</h1>
    </div>
""", unsafe_allow_html=True)
