colorful_sources = [
  'Application.vala',
  'ColorEntry.vala',
  'Window.vala',
  'main.vala',
]

colorful_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('libportal-gtk4')
]

conf = configuration_data()
conf.set_quoted('APP_ID', app_id)
conf.set_quoted('G_LOG_DOMAIN', 'Colorful')
conf.set_quoted('PRETTY_NAME', 'Colorful')
conf.set_quoted('VERSION', meson.project_version())
configure_file(output: 'config.h', configuration: conf)

add_project_arguments(
    '-include', 'config.h',
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

gnome = import('gnome')

colorful_sources += gnome.compile_resources('colorful-resources',
  'resources/colorful.gresource.xml',
  c_name: 'colorful',
  source_dir: 'resources'
)

executable(meson.project_name(), colorful_sources,
  vala_args: [
    '--target-glib=2.50',
    meson.project_source_root() + '/src/vapi/config.vapi',
  ],
  dependencies: colorful_deps,
  install: true,
)
