import streamlit as st
import os


def introduction_page():
    # local css
    def local_css(file_name):
        file_path = os.path.join(os.path.dirname(__file__), file_name)
        with open(file_path) as f:
            st.markdown(f'<style>{f.read()}</style>', unsafe_allow_html=True)

    # Remote pre-defined CSS : 
    def remote_css(url):
        st.markdown(f'<link href="{url}" rel="stylesheet">', unsafe_allow_html=True)

    # call CSS
    local_css("style.css")
    remote_css("https://fonts.googleapis.com/css?family=Roboto")

    # Content
    st.markdown("""
        <div class="app-title">
            <h1>Social Media Influence</h1>
        </div>
    """, unsafe_allow_html=True)



# unsafe_allow_html - allows markdown function to render raw HTML content directly.
