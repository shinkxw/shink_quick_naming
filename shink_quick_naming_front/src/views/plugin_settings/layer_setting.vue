<template>
  <div class="main" v-if="layer_list">
    <div style="margin-top: 20px;margin-right: 10px;position: relative;">
      <h4 style="text-align: center;margin-bottom: 20px;">图层设置</h4>
      <div class="btn btn-default top_btn sort_btn" style="right: 280px;" @click="up_choosed_layer">∧</div>
      <div class="btn btn-default top_btn sort_btn" style="right: 250px;" @click="down_choosed_layer">∨</div>
      <div class="btn btn-default top_btn" style="right: 185px;" @click="import_data">导入</div>
      <div class="btn btn-default top_btn" style="right: 120px;" @click="export_data">导出</div>
      <div class="btn btn-default top_btn" style="right: 14px;" @click="init_data">初始化数据</div>
      <div style="height:550px;overflow-y: auto;">
        <table class="table table-bordered">
          <thead>
            <tr>
              <th>序号</th>
              <th>图层名称</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(layer, index) in layer_list" :key="layer.id"
                :class="{ active: choosed_layer_id == layer.id }"
                @click="choosed_layer_id = layer.id">
              <td>{{ index + 1 }}</td>
              <td>
                <input class="name_input" @input="change_name(layer)"
                          v-model="layer.name">
              </td>
              <td>
                <div class="btn btn-default operate_btn"
                     @click="add_layer(index)">添加</div>
                <div class="btn btn-default operate_btn"
                     @click="delete_layer(layer)">删除</div>
              </td>
            </tr>
            <tr v-if="layer_list.length == 0">
              <td>1</td>
              <td></td>
              <td>
                <div class="btn btn-default operate_btn"
                     @click="add_layer(-1)">添加</div>
              </td>
            </tr>
          </tbody>
        </table>
        <div style="height: 120px"></div>
      </div>
    </div>
    <div style="height: 50px"></div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        layer_list: null,
        choosed_layer_id: null,
      }
    },
    created(){
      window.layer_setting = this
      this.refresh_data()
    },
    methods: {
      refresh_data() {
        udoi('layer', 'data', {}, (data) => {
          this.layer_list = data
          this.$nextTick(() => { cal_and_set_css() })
        })
      },
      import_data() {
        udoi('layer', 'import', {}, () => { this.refresh_data() })
      },
      export_data() {
        udoi('layer', 'export')
      },
      init_data() {
        udoi('layer', 'init', {}, () => { this.refresh_data() })
      },
      up_choosed_layer(){
        if (this.choosed_layer_id){
          udoi('layer', 'up', {id: this.choosed_layer_id}, () => { this.refresh_data() })
        }
      },
      down_choosed_layer(){
        if (this.choosed_layer_id){
          udoi('layer', 'down', {id: this.choosed_layer_id}, () => { this.refresh_data() })
        }
      },
      change_name(layer) {
        var params = {id: layer.id, key: 'name', value: layer.name}
        udoi('layer', 'change_value', params)
      },
      add_layer(index) {
        var insert_index = index + 1
        udoi('layer', 'add_by_index', {index: insert_index}, (layer) => {
          this.layer_list.splice(insert_index, 0, layer)
        })
      },
      delete_layer(layer){
        udoi('layer', 'remove', {id: layer.id}, (data) => { this.layer_list = data })
      }
    }
  }
</script>

<style scoped>
.top_btn{
  position: absolute;
  top: -4px;
}
.sort_btn{
  padding-left: 5px;
  padding-right: 5px;
}
.main{
  overflow-y: auto;
  height: 670px;
  margin-top: 20px;
  margin-left: 20px;
}
.name_input{
  width: 420px;
}
.operate_btn{
  padding-top: 3px;
  padding-bottom: 3px;
  padding-left: 5px;
  padding-right: 5px;
  margin-top: -3px;
  margin-bottom: -3px;
}
</style>
