{
  new(name, url, type, default=false):: {
    name: name,
    type: type,
    access: 'proxy',
    url: url,
    isDefault: default,
    version: 1,
    editable: false,
  },
  withBasicAuth(username, password, legacy=false):: {
    basicAuth: true,
    basicAuthUser: username,
    [if legacy then 'basicAuthPassword']: password,
    [if !legacy then 'secureJsonData']+: {
      basicAuthPassword: password,
    },
  },
  withJsonData(data):: {
    jsonData+: data,
  },
  withHttpMethod(httpMethod):: self.withJsonData({ httpMethod: httpMethod }),
}
