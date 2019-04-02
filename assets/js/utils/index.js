import store from "../app"
import NProgress from "nprogress"

const { scheme, hostname } =
  process.env.NODE_ENV === 'production'
  ? { socketScheme: 'wss'
    , scheme: 'https'
    , hostname: window.location.hostname }
  : { socketScheme: 'ws'
    , scheme: 'http'
    , hostname: 'localhost:4000' };

const defaultHeaders = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
}

const apiURL = `${scheme}://${hostname}/api`;

export function buildHeaders() {
  const token = store.getters.getToken;

  if (token) {
    return Object.assign({}, defaultHeaders, {
      "Authorization": `Bearer ${token}`
    });
  }

  return defaultHeaders;
}

export function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response.data;
  } else if (response.status === 401) {
    return response;
  }

  const data = typeof response.data === "string" ? {message: response.data} : response.data;
  return Promise.reject(Object.assign({code: response.status}, data));
}

export function createApiClient(opts = {}) {
  const axios = require("axios")
    .create(Object.assign(opts, {baseURL: apiURL, timeout: 0, headers: {}}));

  setupResponseErrorFormatter(axios);
  setupNProgressLoader(axios);

  return axios;
}

export function formatDate(datetime, {locale = "es-AR", date = true, time = true, seconds = false, hour12 = false} = {}) {
  let opts = {};
  if (date) {
    opts = Object.assign(opts, {year: "2-digit", month: "2-digit", day: "2-digit"});
  }
  if (time) {
    opts = Object.assign(opts, {hour: "2-digit", minute: "2-digit", hour12});
  }
  if (seconds) {
    opts = Object.assign(opts, {second: "2-digit"});
  }
  return datetime ? (new Date(datetime)).toLocaleString(locale, opts) : "-";
}

export function formatFullName({firstName, lastName}) {
  return firstName && lastName ? `${lastName}, ${firstName}` : firstName || lastName;
}

export function formatBoolean(value, {y = "S", n = "N"} = {}) {
  return Boolean(value) ? y : n;
}

function setupResponseErrorFormatter(http) {
  http.interceptors.response.use((response) => {
    return response;
  }, (error) => {
    return Promise.reject(error.response);
  });
}

function setupNProgressLoader(http) {
  http.interceptors.request.use((config) => {
    NProgress.start();
    return config;
  }, (error) => {
    NProgress.done();
    return Promise.reject(error);
  });
  
  http.interceptors.response.use((response) => {
    NProgress.done();
    return response;
  }, (error) => {
    NProgress.done();
    return Promise.reject(error);
  });
}