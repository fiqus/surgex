<template>
  <div>
    <table class="custom-table">
      <thead>
        <th v-for="header in headers" :key="header.key">
          {{ header.value }}
        </th>
        <th v-if="!params.hideActions">Acciones</th>
      </thead>
      <tbody>
        <tr v-for="elem in data" :key="elem.id">
          <td class="cursor-pointer" v-for="header in headers" @click.stop="onClick(elem)" :key="header.key">
            {{ parseElem(header, elem) }}
          </td>
          <td v-if="!params.hideActions">
            <button v-if="!params.hideEdit" class="btn btn-primary" @click.stop="onEdit(elem)" title="Editar"><i class="fa fa-edit"></i></button>
            <button v-if="!params.hideDelete" class="btn btn-danger" @click.stop="onDelete(elem)" title="Eliminar"><i class="fa fa-trash"></i></button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
<script>
const params = {
	hideActions: false,
  hideEdit: false,
  hideDelete: false
};

export default {
  props: {
    headers: {
      type: Array,
      default: [],
      required: true
    },
    data: {
      type: Array,
      default: [],
      required: true
    },
    params: {
      type: Object,
      default: () => params,
      required: false
    }
  },
  data() {
    return {
      parseElem(header, elem) {
        if (header.parser) {
            try {
              return header.parser(elem);
            } catch (err) {
              console.trace(`Can't parse the element for '${header.key}'!`, err);
            }
          }
          return elem[header.key];
      }
    };
  },
  methods: {
    onClick(elem) {
      this.$emit("onClick", elem);
    },
    onEdit(elem) {
      this.$emit("onEdit", elem);
    },
    onDelete(elem) {
      this.$emit("onDelete", elem);
    }
  }
}
</script>

