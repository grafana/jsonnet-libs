function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
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
          },
        },
      },
      imageCount: {
        name: 'Image count',
        nameShort: 'Images',
        type: 'gauge',
        description: 'Number of image elements loaded.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_image_count{%(queriesSelector)s}',
          },
        },
      },
      htmlCount: {
        name: 'HTML count',
        nameShort: 'HTML',
        type: 'gauge',
        description: 'Number of HTML elements loaded.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_html_count{%(queriesSelector)s}',
          },
        },
      },
      cssCount: {
        name: 'CSS count',
        nameShort: 'CSS',
        type: 'gauge',
        description: 'Number of CSS elements loaded.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_css_count{%(queriesSelector)s}',
          },
        },
      },
      scriptCount: {
        name: 'Script count',
        nameShort: 'Scripts',
        type: 'gauge',
        description: 'Number of script elements loaded.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_script_count{%(queriesSelector)s}',
          },
        },
      },
      fontCount: {
        name: 'Font count',
        nameShort: 'Fonts',
        type: 'gauge',
        description: 'Number of font elements loaded.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_font_count{%(queriesSelector)s}',
          },
        },
      },
      xmlCount: {
        name: 'XML count',
        nameShort: 'XML',
        type: 'gauge',
        description: 'Number of XML elements loaded.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_xml_count{%(queriesSelector)s}',
          },
        },
      },
      mediaCount: {
        name: 'Media count',
        nameShort: 'Media',
        type: 'gauge',
        description: 'Number of media elements loaded.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_media_count{%(queriesSelector)s}',
          },
        },
      },
    },
  }
