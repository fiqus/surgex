<template>
  <div>
    <select v-model="selected">
      <option v-if="firstOption" value="">{{firstOption}}</option>
      <option v-for="option in options" :key="option.key" :value="option.key">{{option.value}}</option>
    </select>
    <button type="button" v-on:click.stop="onAdd" class="button"><i class="fa fa-plus"></i></button>

    <div v-if="value.length > 0" style="width: calc(100% - 63px);">
      <div v-for="item in value" :key="item">
        <span>{{getValue(item)}}</span>
      </div>
    </div>
  </div>
</template>
<script>
  export default {
    props: ["options", "firstOption", "value"],
    methods: {
      onAdd() {
        if (this.selected) {
          this.value.push(this.selected);
          this.$emit("input", this.value);
        }
      },
      getValue(item) {
        if (item) {
          return this.options.find((op) => {
            return op.key === item;
          }).value;
        }
      }
    },
    data() {
      return {
        selected: ""
      }
    }
  }
</script>
