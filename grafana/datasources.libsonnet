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
  withBasicAuth(username, password):: {
    basicAuth: true,
    basicAuthUser: username,
    basicAuthPassword: password,
  },
  withJsonData(data):: {
    jsonData+: data,
  },
  withHttpMethod(httpMethod):: self.withJsonData({ httpMethod: httpMethod }),
}
