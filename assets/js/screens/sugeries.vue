<template>
  <div>
    <h3 class="subtitle">Listado de Cirugías</h3>
    <div><a v-on:click="addSurgery" href="#">Agregar cirugía</a></div>
    <div class="center">
      <h4 v-if="!surgeries.length">Aún no tiene cirugías cargadas</h4>
      <button v-on:click="addSurgery" class="button">
        <i class="fa fa-plus"></i>
        Agregar cirugía
      </button>
    </div>
  </div>
</template>

<script>
export default {
  created() {
    return this.$store.dispatch("fetchSurgeries");
  },
  computed: {
    surgeries: {
      get() {
        return this.$store.state.surgeries;
      }
    }
  },
  methods: {
    addSurgery() {
      this.$router.push({name: "newSurgery"});
    }
  }
}
</script>