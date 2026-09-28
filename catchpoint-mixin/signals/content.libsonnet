// Per-content-type sizes and element counts, feeding the pie chart and bar gauge
// on the two drilldown dashboards. `pivot` is the label each series is aggregated
// by; these breakdowns collapse to the dashboard's own label, so the legend names
// the content type rather than the pivot.
function(this, pivot)
  {
    filteringSelector: this.drilldownSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    datasource: 'prometheus_datasource',
    aggLevel: 'aggKeepLabels',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'catchpoint_image_content_type',
    },
    signals: {
      imageContentSize: {
        name: 'Image content size',
        nameShort: 'Image size',
        type: 'gauge',
        description: 'Size of image content loaded.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_image_content_type{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'image',
          },
        },
      },
      htmlContentSize: {
        name: 'HTML content size',
        nameShort: 'HTML size',
        type: 'gauge',
        description: 'Size of HTML content loaded.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_html_content_type{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'html',
          },
        },
      },
      cssContentSize: {
        name: 'CSS content size',
        nameShort: 'CSS size',
        type: 'gauge',
        description: 'Size of CSS content loaded.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_css_content_type{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'css',
          },
        },
      },
      scriptContentSize: {
        name: 'Script content size',
        nameShort: 'Script size',
        type: 'gauge',
        description: 'Size of script content loaded.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_script_content_type{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'script',
          },
        },
      },
      fontContentSize: {
        name: 'Font content size',
        nameShort: 'Font size',
        type: 'gauge',
        description: 'Size of font content loaded.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_font_content_type{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'font',
          },
        },
      },
      xmlContentSize: {
        name: 'XML content size',
        nameShort: 'XML size',
        type: 'gauge',
        description: 'Size of XML content loaded.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_xml_content_type{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'xml',
          },
        },
      },
      mediaContentSize: {
        name: 'Media content size',
        nameShort: 'Media size',
        type: 'gauge',
        description: 'Size of media content loaded.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_media_content_type{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'media',
          },
        },
      },
      imageCount: {
        name: 'Image count',
        nameShort: 'Images',
        type: 'gauge',
        description: 'Number of image elements loaded.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'catchpoint_image_count{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'image',
          },
        },
      },
      htmlCount: {
        name: 'HTML count',
        nameShort: 'HTML',
        type: 'gauge',
        description: 'Number of HTML elements loaded.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'catchpoint_html_count{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'html',
          },
        },
      },
      cssCount: {
        name: 'CSS count',
        nameShort: 'CSS',
        type: 'gauge',
        description: 'Number of CSS elements loaded.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'catchpoint_css_count{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'css',
          },
        },
      },
      scriptCount: {
        name: 'Script count',
        nameShort: 'Scripts',
        type: 'gauge',
        description: 'Number of script elements loaded.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'catchpoint_script_count{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'script',
          },
        },
      },
      fontCount: {
        name: 'Font count',
        nameShort: 'Fonts',
        type: 'gauge',
        description: 'Number of font elements loaded.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'catchpoint_font_count{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'font',
          },
        },
      },
      xmlCount: {
        name: 'XML count',
        nameShort: 'XML',
        type: 'gauge',
        description: 'Number of XML elements loaded.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'catchpoint_xml_count{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'xml',
          },
        },
      },
      mediaCount: {
        name: 'Media count',
        nameShort: 'Media',
        type: 'gauge',
        description: 'Number of media elements loaded.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'catchpoint_media_count{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'media',
          },
        },
      },
    },
  }
