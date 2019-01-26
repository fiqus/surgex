<template>
  <div id="surgeons-list" v-if="!loading">
    <h3 class="subtitle">Listado de CIrujanos</h3>
    <div><a href="/#/surgeons/new">Crear nuevo cirujano</a></div>
    <table>
      <thead>
        <th>Email</th>
        <th>Admin</th>
        <th>Acciones</th>
      </thead>
      <tbody>
        <tr v-for="surgeon in surgeons" :key="surgeon.id">
          <td><a @click="showDetail(surgeon)">{{ surgeon.email }}</a></td>
          <td>{{ surgeons.user.isAdmin ? "S" : "N" }}</td>
          <td>
            <a :href="`/#/surgeons/edit/${surgeon.id}`">Editar</a>
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
    showDetail(surgeon) {
      this.$router.push({name: "surgeons-show", params: {surgeonId: surgeon.id}})
    },
    onDelete(surgeon) {
      if (!confirm(`¿Eliminar al cirujano ${surgeon.email}?`)) {
        return false;
      }
      
      this.$store.dispatch("deleteSurgeon", surgeon.id)
        .then((rs) => {
          this.surgeons = this.surgeons.filter((s) => {
            return s.id !== surgeon.id;
          });
        });
    }
  }
}
</script>
