<template>
  <div>
    <h3 class="subtitle">Nueva Cirugía</h3>
    <button v-on:click="backToList" class="button">
      <i class="fa fa-caret-left"></i>
      Volver al listado
    </button>
  </div>
</template>
<script>
export default {
  methods: {
    backToList() {
      this.$router.push({name: "surgeries"});
    }
  }
}
</script>

