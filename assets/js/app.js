// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

import "phoenix_html"
import Vue from "vue"
import VueRouter from "vue-router"
import Vuex from "vuex"

import {initialState, getters, mutations, actions} from "./state/store";

import App from "./App"

import HomeScreen from "./screens/home.vue";
import LoginScreen from "./screens/login.vue";
import PatientScreen from "./screens/patient.vue";

Vue.config.debug = true;
Vue.config.devtools = true;
Vue.config.silent = false;

Vue.use(VueRouter)
Vue.use(Vuex)

const router = new VueRouter({
  routes: [
    {name: "home", path: "/", component: HomeScreen},
    {name: "login", path: "/login", component: LoginScreen},
    {name: "patient", path: "/patient/:patientId", component: PatientScreen},
    // Default redirect to home
    { path: "*", redirect: "/" }
  ],
  scrollBehavior() {
    return {x: 0, y: 0};
  }
});

// Redirect to login page if not logged in and trying to access a restricted page
router.beforeEach((to, from, next) => {
  const publicPages = ["/", "/login"],
    authRequired = (path) => {
      return !publicPages.includes(path);
    };

  // @TODO: Just for testing purposes..!
  App.setUser({token: "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJnYXJyYWhhbiIsImV4cCI6MTU0NzQwMDkzNSwiaWF0IjoxNTQ3MzE0NTM1LCJpc3MiOiJnYXJyYWhhbiIsImp0aSI6ImZiZDU4Y2RkLTIxYWEtNDQ1NC1hMWU0LTRhZDRlMjJiNDdlOCIsIm5iZiI6MTU0NzMxNDUzNCwic3ViIjoiOTU0NmY0NzEtNDkwYy00ZDIwLThlODQtYWUxYjUzY2NhYzE5IiwidHlwIjoiYWNjZXNzIn0.DgTNP76ja-Ka6BTVLTTTdDhNtAGfb2wfvyATRa-z_J0KG2DWdM64wySoE9ydhJMhg1s4OKbdYgF5cgmWsvJUCg"});

  if (authRequired(to.path) && !App.getUser()) {
    return next("/login");
  }

  next();
})

const store = new Vuex.Store({
  state: initialState,
  getters,
  mutations,
  actions
});

new Vue({
  el: '#app',
  store,
  router,
  template: '<App/>',
  components: { App }
});