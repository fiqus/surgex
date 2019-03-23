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

export function formatDate(date) {
  const opts = {year: "2-digit", month: "2-digit", day: "2-digit", hour: "2-digit", minute: "2-digit", hour12: false};
  return date ? (new Date(date)).toLocaleString("es-AR", opts) : "-";
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