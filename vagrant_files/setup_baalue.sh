#!/usr/bin/env bash
pushd ~
BAALUE_REPO=https://github.com/tjohann/baalue_sdk.git
BAALUE_BASE_DIR=$(basename ${BAALUE_REPO%.*})
BAALUE_DOCS_DIR=${BAALUE_BASE_DIR}/Documentation
BAALUE_ROOT_MD=README.md
BAALUE_PICS_DIR=${BAALUE_BASE_DIR}/pics
GUI_HELP_DIR=/vagrant/baalue_help

# setup baalue in the home directory
git clone ${BAALUE_REPO}

# get rid of any old help files by removing the folder
if [ -d ${GUI_HELP_DIR} ]; then
    rm -rf ${GUI_HELP_DIR}
fi

# recreate the tree structure and copy the pics folder completely
mkdir -p ${GUI_HELP_DIR}
pushd ${BAALUE_BASE_DIR}
find . -type d -exec mkdir -p ${GUI_HELP_DIR}/{} \; -exec cp -r /vagrant/css ${GUI_HELP_DIR}/{}/ \;
popd
cp -r ${BAALUE_PICS_DIR} ${GUI_HELP_DIR}/
cp -r ${BAALUE_DOCS_DIR} ${GUI_HELP_DIR}/
pushd /vagrant
CSS_OPTION=$(find css -iname "*.css" -type f | perl -pe "s/^/-c /; s/\n/ /;g")
popd

#convert all md files to html in the target folder
pushd ${BAALUE_BASE_DIR}
find . \( -iname "*.md" -o -iname "*.txt" \) -exec cp {} ${GUI_HELP_DIR}/{} \;
popd

pushd /vagrant
python convert_md.py -b baalue_help/ --header header.htm --footer footer.htm
popd

cp ${GUI_HELP_DIR}/${BAALUE_ROOT_MD}.htm ${GUI_HELP_DIR}/index.htm 

popd
