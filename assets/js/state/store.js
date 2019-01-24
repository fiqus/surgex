const apiClient = require("../utils/api-client");

const initialState = {
  authUser: null,
  token: null,
  patient: null,
  surgeries: []
};

const actions = {
  login({commit}, data) {
    return apiClient.httpPost("/token", data)
      .then((res) => {
        commit("setAuthUser", res);
      });
  },
  fetchPatient({commit}, {patientId}) {
    return apiClient.httpGet(`/patients/${patientId}`)
      .then((patient) => {
        commit("setPatient", patient);
      });
  },
  fetchUsers() {
    return apiClient.httpGet("/users")
      .then((res) => {
        return res.data;
      });
  },
  fetchUser(_, userId) {
    return apiClient.httpGet(`/users/${userId}`)
      .then((res) => {
        return res.data;
      });
  },
  deleteUser(_, userId) {
    return apiClient.httpDelete(`/users/${userId}`)
      .then((res) => {
        return res.data;
      });
  },
  fetchSurgeries({commit}) {
    return apiClient.httpGet("/surgeries")
      .then((res) => {
        commit("setSurgeries", res.data);
      });
  }
};

const mutations = {
  setAuthUser(state, authUser) {
    state.authUser = authUser.user;
    state.token = authUser.token;
  },
  setPatient(state, patient) {
    state.patient = patient;
  },
  setSurgeries(state, surgeries) {
    state.surgeries = surgeries;
  }
};

const getters = {
  getToken(state) {
    return state.token;
  }
};

module.exports = {
  initialState,
  getters,
  mutations,
  actions
};