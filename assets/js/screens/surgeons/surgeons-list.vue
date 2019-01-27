<template>
  <div id="surgeons-list" v-if="!loading">
    <h3 class="subtitle">Listado de Cirujanos</h3>
    <div><a @click="showNew()">Crear nuevo cirujano</a></div>
    <table>
      <thead>
        <th>Cirujano</th>
        <th>Email</th>
        <th>Acciones</th>
      </thead>
      <tbody>
        <tr v-for="surgeon in surgeons" :key="surgeon.id">
          <td><a @click="showDetail(surgeon)">{{ surgeon.lastName }}, {{ surgeon.firstName }}</a></td>
          <td>{{ surgeon.email }}</td>
          <td>
            <a @click="showEdit(surgeon)">Editar</a>
            |
            <a @click="onDelete(surgeon)">Eliminar</a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
export default {
  data() {
    return {
      surgeons: [],
      loading: true
    }
  },
  created() {
    this.$store.dispatch("fetchSurgeons")
      .then((surgeons) => {
        this.surgeons = surgeons;
        this.loading = false;
      });
  },
  methods: {
    showNew() {
      this.$router.push({name: "surgeons-new"});
    },
    showDetail(surgeon) {
      this.$router.push({name: "surgeons-show", params: {surgeonId: surgeon.id}});
    },
    showEdit(surgeon) {
      this.$router.push({name: "surgeons-edit", params: {surgeonId: surgeon.id}});
    },
    onDelete(surgeon) {
      if (confirm(`¿Eliminar al cirujano ${surgeon.lastName}, ${surgeon.firstName}?`)) {
        this.$store.dispatch("deleteSurgeon", surgeon.id)
          .then((rs) => {
            this.surgeons = this.surgeons.filter((s) => {
              return s.id !== surgeon.id;
            });
          });
      }
    }
  }
}
</script>
