<template>
  <div v-if="!loading">
    <h5>{{patient.first_name}}</h5>
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
  }
}
</script>
