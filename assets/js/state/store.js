const {httpGet} = require("../utils/api-client");

const initialState = {
  patient: null
};

const actions = {
  fetchPatient({commit}, {patientId}) {
    return httpGet(`/patients/${patientId}`)
      .then((patient) => {
        commit("setPatient", patient);
      });
  }
};

const mutations = {
  setPatient(state, patient) {
    state.patient = patient;
  }
};

const getters = {};

module.exports = {
  initialState,
  getters,
  mutations,
  actions
};