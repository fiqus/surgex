const axios = require("axios"),
  {apiURL, buildHeaders, checkStatus} = require("./index");

const client = axios.create({baseURL: apiURL, timeout: 0, headers: {}});

function httpGet(url) {
  return client.get(url, {headers: buildHeaders()})
    .then((response) => {
      return checkStatus(response);
    });
}

function httpPost(url, data) {
  return client.post(url, data, {headers: buildHeaders()})
    .then((response) => {
      return checkStatus(response);
    });
}

module.exports = {
  httpGet,
  httpPost
}