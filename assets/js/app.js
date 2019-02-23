// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
require("vue-awesome-notifications/dist/styles/style.css");
import css from "../css/app.css"

import "phoenix_html"
import Vue from "vue"
import VueRouter from "vue-router"
import Vuex from "vuex"
import createPersistedState from "vuex-persistedstate"
import VueAWN from "vue-awesome-notifications";

import {initialState, getters, mutations, actions} from "./state/store";

import App from "./App"

const options= {
  labels: {
    tip: "Consejo",
    info: "Información",
    success: "¡Hecho!",
    warning: "Atención",
    alert: "¡Error!",
    async: "Cargando",
    confirm: "Confirmar"
  },
  modal: {okLabel: "Sí", cancelLabel: "No"},
  duration: 5000
}

Vue.config.debug = true;
Vue.config.devtools = true;
Vue.config.silent = false;

Vue.use(VueRouter)
Vue.use(Vuex)
Vue.use(VueAWN, options)

import routes from "./routes"
const router = new VueRouter({
  routes,
  scrollBehavior() {
    return {x: 0, y: 0};
  }
});

// Redirect to login page if not logged in and trying to access a restricted page
router.beforeEach((to, from, next) => {
  const publicPages = ["/", "/login", "/users/activate"],
    authRequired = (path) => {
      return !publicPages.includes(path);
    };

  if (authRequired(to.path) && !store.getters.getToken) {
    return next("/login");
  }

  next();
});

const store = new Vuex.Store({
  plugins: [createPersistedState()],
  state: initialState,
  getters,
  mutations,
  actions
});

export default store;

new Vue({
  el: '#app',
  store,
  router,
  template: '<App/>',
  components: {App}
});
