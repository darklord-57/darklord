import streamlit as st
import base64

def introduction_page():
    # Custom CSS :
    def local_css(file_name):
        with open(file_name) as f:
            st.markdown(f'<style>{f.read()}</style>', unsafe_allow_html=True)

    # Remote pre-defined CSS : 
    def remote_css(url):
        st.markdown(f'<link href="{url}" rel="stylesheet">', unsafe_allow_html=True)

    # execute CSS
    local_css("style.css")
    remote_css("https://fonts.googleapis.com/css?family=Roboto")

    # App Title
    st.markdown("""
        <div class="app-title">
            <h1>Social Media Influence</h1>
        </div>
    """, unsafe_allow_html=True)



# unsafe_allow_html - allows markdown function to render raw HTML content directly.
