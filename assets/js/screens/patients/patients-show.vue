<template>
  <div v-if="!loading">
    <h3 class="subtitle">Detalle del Paciente</h3>
    <customForm
      :formName="'Editar Paciente'"
      :fields="this.fields"
      :manualData="patient"
      @create="edit">
    </customForm>
    <button v-on:click="backToList" class="button">
      <i class="fa fa-caret-left"></i>
      Volver al listado
    </button>
  </div>
</template>
<script>
import customForm from "../../components/custom-form"
export default {
  components: {
		customForm
	},
  created() {
    this.$store.dispatch("fetchPatient", {patientId: this.$route.params.patientId})
      .then(() => {
        this.loading = false;
      })
  },
  computed: {
    patient: {
      get() {
        return this.$store.state.patient;
      }
    }
  },
  data() {
    return {
      loading: true,
      fields: [
          {key: "first_name", placeholder: "Nombre"},
          {key: "last_name", placeholder: "Apellido"},
          {key: "medical_history", placeholder: "Historia Clínica"}, 
          {key: "address", placeholder: "Dirección"},
          {key: "city", placeholder: "Ciudad"},
          {key: "province", placeholder: "Provincia"},
          {key: "birthdate", type: "date"}
        ]
      }
  },
  methods: {
    backToList() {
      this.$router.push({name: "patients-list"});
    },
    edit: function(payload) {
      return this.$store.dispatch("updatePatient", {component: this, dataPatient: payload, onSuccess: this.backToList})
    }
  },
}
</script>
