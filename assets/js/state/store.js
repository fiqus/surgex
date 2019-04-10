const utils = require("../utils");
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
  fetchPatient(_, patientId) {
    return apiClient.httpGet(`/patients/${patientId}`)
      .then(actions.proccessApiResponse);
  },
  createPatient(_, {component, patient, onSuccess, onError}) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      patient
    };

    actionsHelper.createItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: "/patients",
      loadingMsg: "Creando paciente",
      okMsg: "El paciente ha sido creado.",
      errMsg: "El paciente no pudo ser creado."
    });
  },
  updatePatient(_, {component, patient, onSuccess, onError}) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      id: patient.id,
      patient
    };

    actionsHelper.updateItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: `/patients/${patient.id}`,
      loadingMsg: "Guardando paciente",
      okMsg: "El paciente ha sido guardado.",
      errMsg: "El paciente no pudo ser guardado."
    });
  },
  deletePatient(_, {component, patient, onSuccess, onError}) {
    actionsHelper.deleteItem({component, onSuccess, onError,
      url: `/patients/${patient.id}`,
      question: `¿Eliminar al paciente ${utils.formatFullName(patient)}?`,
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
  updateUser(_, {component, user, onSuccess, onError}) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      id: user.id,
      user: {
        is_admin: user.is_admin,
        disabled: user.disabled
      }
    };

    actionsHelper.updateItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: `/users/${user.id}`,
      loadingMsg: "Guardando usuario",
      okMsg: "El usuario ha sido guardado.",
      errMsg: "El usuario no pudo ser guardado."
    });
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
      question: `¿Eliminar al cirujano ${utils.formatFullName(surgeon)}?`,
      loadingMsg: "Eliminando cirujano",
      okMsg: "El cirujano ha sido eliminado.",
      errMsg: "El cirujano no pudo ser eliminado."
    });
  },
  updateSurgeon(_, {component, surgeon, onSuccess, onError}) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      id: surgeon.id,
      surgeon
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
      surgeon
    };

    actionsHelper.createItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: "/surgeons",
      loadingMsg: "Creando cirujano",
      okMsg: "El cirujano ha sido creado.",
      errMsg: "El cirujano no pudo ser creado."
    });
  },
  fetchDiagnostics() {
    return apiClient.httpGet("/diagnostics")
      .then(actions.proccessApiResponse);
  },
  fetchDiagnostic(_, diagnosticId) {
    return apiClient.httpGet(`/diagnostics/${diagnosticId}`)
      .then(actions.proccessApiResponse);
  },
  deleteDiagnostic(_, {component, diagnostic, onSuccess, onError}) {
    actionsHelper.deleteItem({component, onSuccess, onError,
      url: `/diagnostics/${diagnostic.id}`,
      question: `¿Eliminar el diagnóstico ${diagnostic.name}?`,
      loadingMsg: "Eliminando diagnóstico",
      okMsg: "El diagnóstico ha sido eliminado.",
      errMsg: "El diagnóstico no pudo ser eliminado."
    });
  },
  updateDiagnostic(_, {component, diagnostic, onSuccess, onError}) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      id: diagnostic.id,
      diagnostic
    };

    actionsHelper.updateItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: `/diagnostics/${diagnostic.id}`,
      loadingMsg: "Guardando diagnóstico",
      okMsg: "El diagnóstico ha sido guardado.",
      errMsg: "El diagnóstico no pudo ser guardado."
    });
  },
  createDiagnostic(_, {component, diagnostic, onSuccess, onError}) {
    const data = {
      diagnostic
    };

    actionsHelper.createItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: "/diagnostics",
      loadingMsg: "Creando diagnóstico",
      okMsg: "El diagnóstico ha sido creado.",
      errMsg: "El diagnóstico no pudo ser creado."
    });
  },
  fetchSurgeries() {
    return apiClient.httpGet("/surgeries")
      .then(actions.proccessApiResponse);
  },
  fetchSurgery(_, surgeryId) {
    return apiClient.httpGet(`/surgeries/${surgeryId}`)
      .then(actions.proccessApiResponse);
  },
  updateSurgery(_, {component, surgery, onSuccess, onError}) {
    // @TODO We should consider this format at backend, doesn't make much sense as it is
    const data = {
      id: surgery.id,
      // @TODO Review this!
      surgery: Object.assign(surgery, {
        patient_id: surgery.patient.id,
        surgeon_id: surgery.surgeon.id,
        diagnostic_id: surgery.diagnostic.id
      })
    };

    actionsHelper.updateItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: `/surgeries/${surgery.id}`,
      loadingMsg: "Guardando cirugía",
      okMsg: "La cirugía ha sido guardada.",
      errMsg: "La cirugía no pudo ser guardada."
    });
  },
  createSurgery(_, {component, surgery, onSuccess, onError}) {
    const data = {
      // @TODO Review this!
      surgery: Object.assign(surgery, {
        patient_id: surgery.patient.id,
        surgeon_id: surgery.surgeon.id,
        diagnostic_id: surgery.diagnostic.id
      })
    };

    actionsHelper.createItem({component, onSuccess, onError, data, onResponse: actions.proccessApiResponse,
      url: "/surgeries",
      loadingMsg: "Creando cirugía",
      okMsg: "La cirugía ha sido creada.",
      errMsg: "La cirugía no pudo ser creada."
    });
  },
  deleteSurgery(_, {component, surgery, onSuccess, onError}) {
    actionsHelper.deleteItem({component, onSuccess, onError,
      url: `/surgeries/${surgery.id}`,
      question: `¿Desea eliminar la cirugía seleccionada?`,
      loadingMsg: "Eliminando cirugía",
      okMsg: "La cirugía ha sido eliminada.",
      errMsg: "La cirugía no pudo ser eliminada."
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
  }
};

const getters = {
  isLogged: (state) => state.authUser && state.token,
  isAdmin: (state) => state.authUser && state.authUser.is_admin,
  getUser: (state) => state.authUser,
  getToken: (state) => state.token
};

module.exports = {
  initialState,
  getters,
  mutations,
  actions
};