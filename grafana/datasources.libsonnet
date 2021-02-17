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
    basicAuthPassword: if legacy then password,
    secureJsonData+: if !legacy then {
      basicAuthPassword: password,
    },
  },
  withJsonData(data):: {
    jsonData+: data,
  },
  withHttpMethod(httpMethod):: self.withJsonData({ httpMethod: httpMethod }),
}
