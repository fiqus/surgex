<template>
  <div>
    <table class="table table-striped">
      <thead>
        <th v-for="header in headers" :key="header.key">
          {{ header.value }}
        </th>
        <th v-if="!options.hideActions">Acciones</th>
      </thead>
      <tbody>
        <tr v-for="elem in data" :key="elem.id">
          <td class="cursor-pointer" v-for="header in headers" @click.stop="onClick(elem)" :key="header.key" v-html="parseElem(header, elem)"></td>
          <td v-if="!options.hideActions">
            <button v-if="!options.hideEdit" class="btn btn-primary" @click.stop="onEdit(elem)" title="Editar"><i class="fa fa-edit"></i></button>
            <button v-if="!options.hideDelete" class="btn btn-danger" @click.stop="onDelete(elem)" title="Eliminar"><i class="fa fa-trash"></i></button>
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
  hideDelete: false,
  emptyText: "-"
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
      default: () => {},
      required: false
    }
  },
  data() {
    return {
      options: Object.assign({}, params, this.params),
      parseElem(header, elem) {
        if (header.parser) {
            try {
              return header.parser(elem) || this.options.emptyText;
            } catch (err) {
              console.trace(`Can't parse the element for '${header.key}'!`, err);
            }
          }
          return elem[header.key] || this.options.emptyText;
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

