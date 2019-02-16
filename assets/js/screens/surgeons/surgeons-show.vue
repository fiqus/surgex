<template>
  <div v-if="!loading">
    <h3 class="subtitle">Detalle de Cirujano</h3>
    <section class="elem-details">
      <div><b>Cirujano:</b> {{ surgeon.lastName }}, {{ surgeon.firstName }}</div>
      <div><b>Email:</b> {{surgeon.email}}</div>
      <div><b>Licencia:</b> {{surgeon.license}}</div>
    </section>
    <div class="action-bar-buttons">
      <button v-on:click="$router.go(-1)">Volver</button>
      <button @click="showEdit(surgeon)">Editar</button>
      <button @click="onDelete(surgeon)">Eliminar</button>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      surgeon: null,
      loading: true
    }
  },
  created() {
    this.$store.dispatch("fetchSurgeon", this.$route.params.surgeonId)
      .then((surgeon) => {
        this.surgeon = surgeon;
        this.loading = false;
      });
  },
  methods: {
    showEdit(surgeon) {
      this.$router.push({name: "surgeons-edit", params: {surgeonId: surgeon.id}});
    },
    onDelete(surgeon) {
      const onSuccess = () => {
        this.$router.go(-1);
      };

      this.$store.dispatch("deleteSurgeon", {component: this, surgeon, onSuccess});
    }
  }
}
</script>
