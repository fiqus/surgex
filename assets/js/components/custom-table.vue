<template>
  <div>
    <table>
      <th
      v-for="header in headers">
        {{ header.value }}
      </th>
      <tr
      style="cursor: pointer" 
      v-for="d in data">
        <td 
        v-for="header in headers"
        v-on:click="clicked(d.id)">
          {{ d[header.key] }}
        </td>
        <td v-on:click="deleteRow(d)">
          <i class="fa fa-trash-o"></i>
        </td>
      </tr>
    </table>
  </div>
</template>
<script>
export default {
  props: {
    headers: {
      type: Array,
      default: [],
      required: true,
    },
    data: {
      type: Array,
      default: [],
      required: true,
    }
  },
  data() {
    return {
    }
  },
  computed: {
  },
  methods: {
    clicked(id) {
      this.$emit("clicked", id);
    },
    deleteRow(id) {
      this.$emit("deleteRow", id);
    }
  }
}
</script>

