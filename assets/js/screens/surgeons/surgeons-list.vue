<template>
  <div id="surgeons-list" v-if="!loading">
    <h3 class="subtitle">Listado de Cirujanos</h3>
    <button class="button float-right" v-on:click="showNew">
      <i class="fa fa-plus"></i>
      Agregar Cirujano
    </button>
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
      const success = () => {
        this.surgeons = this.surgeons.filter((s) => {
          return s.id !== surgeon.id;
        });
      };

      this.$store.dispatch("deleteSurgeon", {component: this, surgeon, success});
    }
  }
}
</script>
