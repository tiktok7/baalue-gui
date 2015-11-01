# baalue-gui

Temporary repo for prototype development of GUI frontend for the [baalue sdk](https://github.com/tjohann/baalue_sdk).  When the structure and
functionality has been thoroughly tested this repo will be partially or completely merged into the Baalue
project

# Structure

The front-end is written in QtQuick/QML with asychronous bindings to python via pyotherside The use of
vagrant allows automated setup of a virtual machine that hosts a voidlinux VM on which the Baalue
environment will run. This should allow the same development environment on all platforms (Windows, Linux
and Mac)

# Dependencies
- Qt 5.5
- pyotherside 1.4
- python >= 3.4
- vagrant 1.7.4

# Current Status

- QML/Python: There's some experimental code to test the QML to Python functionality and I played with
  translating md to html on-the-fly with python-markdown. It worked pretty well but the QML Webview
  component doesn't retain any browsing history and doesn't expose interfaces to the functionality behind
  it so it was easier to translate them all at once. I settled on doing this from the backend so the code
  is currently non-functional

- VM: currently running an ubuntu32 VM instead of void linux. The provisioning scripts install the baalue
  repo and create the help files based on the markdown files present in the directories (including adding
  primitive github-like css)

# Attributions

- The current icon files are the product of the Gnome Project. Please refer to the COPYING file in the
  appropriate sub-folder
