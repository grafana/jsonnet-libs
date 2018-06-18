{
  _config+:: {
    namespace: error 'Must define a namespace',

    cookie_secret: error 'Must define a cookie secret',
    client_id: error 'Must define a client id',
    client_secret: error 'Must define a client secret',

    redirect_url: error 'Must define a redirect url',
    upstream: error 'Must define an upstream',

    email_domain: '*',
    pass_basic_auth: 'false',

  },


  _images+:: {
    oauth2_proxy: 'a5huynh/oauth2_proxy:latest',
  },
}
