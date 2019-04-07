import HomeScreen from "./screens/home.vue";
import LoginScreen from "./screens/login.vue";
import RecoverScreen from "./screens/recover.vue";
import RecoverTokenScreen from "./screens/recover-token.vue";
import ActivateScreen from "./screens/activate.vue";
import UsersListScreen from "./screens/users/users-list.vue";
import UsersShowScreen from "./screens/users/users-show.vue";
import UsersFormScreen from "./screens/users/users-form.vue";
import SurgeonsListScreen from "./screens/surgeons/surgeons-list.vue";
import SurgeonsShowScreen from "./screens/surgeons/surgeons-show.vue";
import SurgeonsFormScreen from "./screens/surgeons/surgeons-form.vue";
import PatientsListScreen from "./screens/patients/patients-list.vue";
import PatientsShowScreen from "./screens/patients/patients-show.vue";
import PatientsFormScreen from "./screens/patients/patients-form.vue";
import DiagnosticsListScreen from "./screens/diagnostics/diagnostics-list.vue";
import DiagnosticsShowScreen from "./screens/diagnostics/diagnostics-show.vue";
import DiagnosticsFormScreen from "./screens/diagnostics/diagnostics-form.vue";
import SurgeriesListScreen from "./screens/surgeries/surgeries-list.vue";
import SurgeriesShowScreen from "./screens/surgeries/surgeries-show.vue";
import SurgeriesFormScreen from "./screens/surgeries/surgeries-form.vue";

export default [
  {name: "home", path: "/", component: HomeScreen, meta: {access: "public"}},
  {name: "login", path: "/login", component: LoginScreen, meta: {access: "public"}},
  {name: "recover", path: "/users/recover", component: RecoverScreen, meta: {access: "public"}},
  {name: "recover-token", path: "/users/recover/token", component: RecoverTokenScreen, meta: {access: "public"}},
  {name: "activate", path: "/users/activate", component: ActivateScreen, meta: {access: "public"}},
  {name: "users-list", path: "/users", component: UsersListScreen},
  {name: "users-show", path: "/users/:userId", component: UsersShowScreen},
  {name: "users-edit", path: "/users/edit/:userId", component: UsersFormScreen},
  {name: "surgeons-list", path: "/surgeons", component: SurgeonsListScreen},
  {name: "surgeons-new", path: "/surgeons/new", component: SurgeonsFormScreen},
  {name: "surgeons-edit", path: "/surgeons/edit/:surgeonId", component: SurgeonsFormScreen},
  {name: "surgeons-show", path: "/surgeons/show/:surgeonId", component: SurgeonsShowScreen},
  {name: "patients-list", path: "/patients", component: PatientsListScreen},
  {name: "patients-new", path: "/patients/new", component: PatientsFormScreen},
  {name: "patients-edit", path: "/patients/edit/:patientId", component: PatientsFormScreen},
  {name: "patients-show", path: "/patients/show/:patientId", component: PatientsShowScreen},
  {name: "diagnostics-list", path: "/diagnostics", component: DiagnosticsListScreen},
  {name: "diagnostics-new", path: "/diagnostics/new", component: DiagnosticsFormScreen},
  {name: "diagnostics-edit", path: "/diagnostics/edit/:diagnosticId", component: DiagnosticsFormScreen},
  {name: "diagnostics-show", path: "/diagnostics/show/:diagnosticId", component: DiagnosticsShowScreen},
  {name: "surgeries-list", path: "/surgeries", component: SurgeriesListScreen},
  {name: "surgeries-new", path: "/surgeries/new", component: SurgeriesFormScreen},
  {name: "surgeries-edit", path: "/surgeries/edit/:surgeryId", component: SurgeriesFormScreen},
  {name: "surgeries-show", path: "/surgeries/show/:surgeryId", component: SurgeriesShowScreen},
  // Default redirect to home
  { path: "*", redirect: "/" }
];
