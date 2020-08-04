#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

DIRNAME=$(dirname $0)
if [ "$#" != 2 ] && [ "$#" != 3 ]&& [ "$#" != 4 ]; then
  >&2 echo "arguments invalid"
  echo "Usage: `basename $0` <path to helm chart> <output dir> ['<helm_args>'] [overwrite]"
  exit 1
fi

HELMCHART=$1
OUTPUT_DIR=$2

set +u
OVERWRITTEN=false
if [ "$3" = "overwrite" ] || [ "$4" = "overwrite" ]; then
    rm -rf $OUTPUT_DIR/templates
    rm -rf $OUTPUT_DIR/generated.libsonnet
    [ "$3" = "overwrite" ] && OVERWRITTEN=true
fi
set -u

if [ -e $OUTPUT_DIR/generated.libsonnet ]; then
    >&2 echo "$OUTPUT_DIR/generated.libsonnet exists"
    exit 1
fi

if [ -e $OUTPUT_DIR/templates ]; then
    >&2 echo "$OUTPUT_DIR/templates exists"
    exit 1
fi

NAME=$(basename $OUTPUT_DIR)
TEMP=$(mktemp -d)

function finish {
  rm -rf ${TEMP}
}
trap finish EXIT

set +e
IFS=$' '

set +u
HELMARGS=''
if [ -n "$3" ] && ! $OVERWRITTEN; then
    HELMARGS=$3
fi
set -u

if [ -f $OUTPUT_DIR/values.yaml ]; then
    HELMARGS="${HELMARGS} -f $OUTPUT_DIR/values.yaml"
fi

helm template \
    'XX_HELM_RELEASE_XX' \
    $HELMCHART \
    ${HELMARGS} \
    --namespace 'XX_HELM_NAMESPACE_XX' \
    --output-dir ${TEMP}

TEMPLATES=$TEMP/*/templates
mkdir -p $OUTPUT_DIR/templates
cp $TEMPLATES/* $OUTPUT_DIR/templates

set -e
IFS=$'\n\t'

cp $DIRNAME/templated.libsonnet $OUTPUT_DIR # Should get replaced by a jsonnet lib

OUT=''
OUT="${OUT}{\n"
OUT="${OUT}local templated = (import 'templated.libsonnet') { _config+:: $._config },\n\n"

for f in $(ls $OUTPUT_DIR/templates)
do
    OUT="${OUT}'$(basename $f|awk -F'.yaml' '{print $1}'|sed 's/-/_/g')': templated.configureHelmChart(importstr 'templates/$f'),\n"
done

OUT=${OUT}'}'

echo -e ${OUT} | jsonnetfmt -
echo -e ${OUT} | jsonnetfmt - > $OUTPUT_DIR/generated.libsonnet

if [ -e $OUTPUT_DIR/main.libsonnet ]; then
    echo "$OUTPUT_DIR/main.libsonnet exists"
    echo "Import generated libsonnet with \`import '$OUTPUT_DIR/generated.libsonnet'\`"
else
    cat <<EOF > $OUTPUT_DIR/main.libsonnet
local generated = import 'generated.libsonnet';
generated {
  _config+:: {
    name: '$NAME',
    namespace: error 'must provide namespace',
    chartPrefix: '$NAME',
  },
  // Add permanent patches here
}
EOF
    echo "$OUTPUT_DIR/main.libsonnet generated"
fi
