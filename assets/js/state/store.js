const apiClient = require("../utils/api-client");
const actionsHelper = require("../utils/actions-helper");

const initialState = {
  authUser: null,
  token: null,
  patient: null,
  surgeries: []
};

const actions = {
  proccessApiResponse(res) {
    if (res.status === 401) {
      return actions.logout();
    }

    return res.data;
  },
  login({commit}, data) {
    return apiClient.httpPost("/token", data)
      .then((res) => {
        commit("setAuthUser", res);
        return res.user;
      });
  },
  logout() {
    localStorage.clear();
    return window.location.reload();
  },
  isAuth({commit}, token) {
    function clearAuthUser() {
      commit("clearAuthUser");
    }

    return !token ? clearAuthUser() : apiClient.httpPost("/auth", {token})
      .then((res) => {
        if (!(res && res.auth)) {
          throw new Error("Token is not valid anymore! => Will call clearAuthUser()");
        }
      })
      .catch(clearAuthUser);
  },
  postRecover(_, email) {
    return apiClient.httpPost("/users/recover", {email});
  },
  getRecover(_, token) {
    return apiClient.httpGet("/users/recover", {token});
  },
  putRecover(_, data) {
    return apiClient.httpPut("/users/recover", data)
      .then(actions.proccessApiResponse);
  },
  getActivate(_, token) {
    return apiClient.httpGet("/users/activate", {token})
      .then(actions.proccessApiResponse);
  },
  putActivate(_, data) {
    return apiClient.httpPut("/users/activate", data)
      .then(actions.proccessApiResponse);
  },
  fetchPatients() {
    return apiClient.httpGet("/patients")
      .then(actions.proccessApiResponse);
  },
  fetchPatient({commit}, {patientId}) {
    return apiClient.httpGet(`/patients/${patientId}`)
      .then(actions.proccessApiResponse)
      .then((patient) => {
        // @TODO This shouldn't be needed anymore!
        commit("setPatient", patient);
      });
  },
  createPatient(_, {component, data, onSuccess, onError}) {
    actionsHelper.createItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: "/patients",
      loadingMsg: "Creando paciente",
      okMsg: "El paciente ha sido creado.",
      errMsg: "El paciente no pudo ser creado."
    });
  },
  updatePatient(_, {component, dataPatient, onSuccess, onError}) {
    const data = {
      id: dataPatient.id,
      patient: {
        first_name: dataPatient.first_name,
        last_name: dataPatient.last_name,
        medical_history: dataPatient.medical_history,
        address: dataPatient.address,
        city: dataPatient.city,
        province: dataPatient.province,
        birthdate: dataPatient.birthdate
      }
    };

    actionsHelper.updateItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: `/patients/${dataPatient.id}`,
      loadingMsg: "Guardando paciente",
      okMsg: "El paciente ha sido guardado.",
      errMsg: "El paciente no pudo ser guardado."
    });
  },
  deletePatient(_, {component, dataPatient, onSuccess, onError}) {
    actionsHelper.deleteItem({component, onSuccess, onError,
      url: `/patients/${dataPatient.id}`,
      question: `¿Eliminar al paciente ${dataPatient.last_name}, ${dataPatient.first_name}?`,
      loadingMsg: "Eliminando paciente",
      okMsg: "El paciente ha sido eliminado.",
      errMsg: "El paciente no pudo ser eliminado."
    });
  },
  fetchUsers() {
    return apiClient.httpGet("/users")
      .then(actions.proccessApiResponse);
  },
  fetchUser(_, userId) {
    return apiClient.httpGet(`/users/${userId}`)
      .then(actions.proccessApiResponse);
  },
  updateUser(_, user) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      id: user.id,
      user: {
        is_admin: user.isAdmin,
        disabled: user.disabled
      }
    };

    return apiClient.httpPut(`/users/${user.id}`, data)
      .then(actions.proccessApiResponse);
  },
  fetchSurgeons() {
    return apiClient.httpGet("/surgeons")
      .then(actions.proccessApiResponse);
  },
  fetchSurgeon(_, surgeonId) {
    return apiClient.httpGet(`/surgeons/${surgeonId}`)
      .then(actions.proccessApiResponse);
  },
  deleteSurgeon(_, {component, surgeon, onSuccess, onError}) {
    actionsHelper.deleteItem({component, onSuccess, onError,
      url: `/surgeons/${surgeon.id}`,
      question: `¿Eliminar al cirujano ${surgeon.lastName}, ${surgeon.firstName}?`,
      loadingMsg: "Eliminando cirujano",
      okMsg: "El cirujano ha sido eliminado.",
      errMsg: "El cirujano no pudo ser eliminado."
    });
  },
  updateSurgeon(_, {component, surgeon, onSuccess, onError}) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      id: surgeon.id,
      surgeon: {
        first_name: surgeon.firstName,
        last_name: surgeon.lastName,
        email: surgeon.email,
        license: surgeon.license
      }
    };

    actionsHelper.updateItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: `/surgeons/${surgeon.id}`,
      loadingMsg: "Guardando cirujano",
      okMsg: "El cirujano ha sido guardado.",
      errMsg: "El cirujano no pudo ser guardado."
    });
  },
  createSurgeon(_, {component, surgeon, onSuccess, onError}) {
    const data = {
      user: {
        is_admin: false
      },
      surgeon: {
        first_name: surgeon.firstName,
        last_name: surgeon.lastName,
        email: surgeon.email,
        license: surgeon.license
      }
    };

    actionsHelper.createItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: "/surgeons",
      loadingMsg: "Creando cirujano",
      okMsg: "El cirujano ha sido creado.",
      errMsg: "El cirujano no pudo ser creado."
    });
  },
  fetchSurgeries({commit}) {
    return apiClient.httpGet("/surgeries")
      .then(actions.proccessApiResponse)
      .then((surgeries) => {
        // @TODO This shouldn't be needed anymore!
        commit("setSurgeries", surgeries);
      });
  },
  createSurgery(_, {component, surgery, onSuccess, onError}) {
    actionsHelper.createItem({component, onSuccess, onError, data: {surgery}, onResponse: actions.proccessApiResponse,
      url: "/surgeries",
      loadingMsg: "Creando cirugia",
      okMsg: "La cirugia ha sido creada.",
      errMsg: "La cirugia no pudo ser creada."
    });
  },
  deleteSurgery(_, {component, surgery, onSuccess, onError}) {
    actionsHelper.deleteItem({component, onSuccess, onError,
      url: `/surgeries/${surgery.id}`,
      question: `¿Desea eliminar la cirugia seleccionada?`,
      loadingMsg: "Eliminando cirugia",
      okMsg: "La cirgua ha sido eliminada.",
      errMsg: "La cirgua no pudo ser eliminada."
    });
  },
};

const mutations = {
  setAuthUser(state, authUser) {
    state.authUser = authUser.user;
    state.token = authUser.token;
  },
  clearAuthUser(state) {
    state.authUser = null;
    state.token = null;
  },
  // @TODO This shouldn't be needed anymore!
  setPatient(state, patient) {
    state.patient = patient;
  },
  // @TODO This shouldn't be needed anymore!
  setSurgeries(state, surgeries) {
    state.surgeries = surgeries;
  }
};

const getters = {
  isLogged: (state) => state.authUser && state.token,
  isAdmin: (state) => state.authUser && state.authUser.isAdmin,
  getUser: (state) => state.authUser,
  getToken: (state) => state.token
};

module.exports = {
  initialState,
  getters,
  mutations,
  actions
};