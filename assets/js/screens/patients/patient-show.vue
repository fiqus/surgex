<template>
  <div v-if="!loading">
    <h3 class="subtitle">Detalle del Paciente</h3>
    <div> <b>Nombre:</b> {{patient.first_name}} </div>
    <div> <b>Apellido:</b> {{patient.last_name}} </div>
    <div> <b>Dirección:</b> {{patient.address}} </div>
    <div> <b>Ciudad:</b> {{patient.city}} </div>
    <div> <b>Provincia:</b> {{patient.province}} </div>
    <div> <b>Fecha de Cumpleaños:</b> {{patient.birthdate}} </div>
    <button v-on:click="backToList" class="button">
      <i class="fa fa-caret-left"></i>
      Volver al listado
    </button>
  </div>
</template>
<script>
export default {
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
    }
  },
  methods: {
    backToList() {
      this.$router.push({name: "patients-list"});
    }
  },
}
</script>
