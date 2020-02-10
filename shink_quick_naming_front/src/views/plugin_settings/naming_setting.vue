<template>
  <div style="width: 100%;height: 870px;position: relative;">
    <div class="top_box">
      <div class="attr_row">
        <div class="btn btn-default top_btn" @click.stop="init_data">初始化数据</div>
        <div class="btn btn-default top_btn" @click.stop="export_data">导出</div>
        <div class="btn btn-default top_btn" @click.stop="import_data">导入</div>
      </div>
    </div>
    <div class="left_bar">
      <div class="mc_list">
        <div class="btn btn-default add_btn" @click="add_category('mc')">添加分类</div>
        <div class="btn btn-default sort_btn" @click="move_choosed_category('mc', 'up')">∧</div>
        <div class="btn btn-default sort_btn" @click="move_choosed_category('mc', 'down')">∨</div>
        <div class="option_box" :class="{ active: choosed_mcid == mc.id }"
          v-for="(mc, index) in setting_data" @click.stop="choose_mc(mc)">
          <div class="option_line">
            <label style="margin-top: 5px;">{{index+1}}.</label>
            <input v-if="choosed_mcid == mc.id && choosed_scid == null" type="text"
                   class="cname_input" @input="change_cname('mc', mc)" v-model="mc.name">
            <label v-else style="margin-top: 5px;">{{mc.name}}</label>
            <div class="destroy" @click.stop="remove_category('mc', mc)"></div>
          </div>
        </div>
      </div>
      <div class="sc_list">
        <div class="btn btn-default add_btn" @click="add_category('sc')">添加分类</div>
        <div class="btn btn-default sort_btn" @click="move_choosed_category('sc', 'up')">∧</div>
        <div class="btn btn-default sort_btn" @click="move_choosed_category('sc', 'down')">∨</div>
        <div style="height:547px;overflow-y: auto;">
          <div class="option_box" :class="{ active: choosed_scid == sc.id }"
            v-for="(sc, index) in sc_arr" @click.stop="choose_sc(sc)">
            <div class="option_line">
              <label style="margin-top: 5px;">{{index+1}}.</label>
              <input v-if="choosed_scid == sc.id" type="text"
                     class="cname_input" @input="change_cname('sc', sc)" v-model="sc.name">
              <label v-else style="margin-top: 5px;">{{sc.name}}</label>
              <div class="destroy" @click.stop="remove_category('sc', sc)"></div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="right_bar" @click.stop="">
      <div v-if="current_category" style="height:575px;overflow-y: auto;">
        <table class="table table-bordered">
          <thead>
            <tr>
              <th>序号</th>
              <th>名称</th>
              <th>图层</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(row, index) in data_arr" :key="row.id"
                :class="{ active: choosed_rowid == row.id }"
                @mousedown="choosed_rowid = row.id">
              <td>{{ index + 1 }}</td>
              <td>
                <input class="name_input" @input="change_row_attr(row, 'name')"
                          v-model="row.name">
              </td>
              <td>
                <obj-select :arr="layer_list" @input="change_row_attr(row, 'layer_id')"
                              v-model="row.layer_id"
                              width="260px" tip="可关联图层"></obj-select>
              </td>
              <td>
                <div class="btn btn-default operate_btn"
                     @click="add_row(index)">添加</div>
                <div class="btn btn-default operate_btn"
                     @click="move_row(row, 'up')">上移</div>
                <div class="btn btn-default operate_btn"
                     @click="move_row(row, 'down')">下移</div>
                <div class="btn btn-default operate_btn"
                     @click="remove_row(row)">删除</div>
              </td>
            </tr>
            <tr v-if="data_arr.length == 0">
              <td>1</td>
              <td></td>
              <td></td>
              <td></td>
              <td>
                <div class="btn btn-default operate_btn"
                     @click="add_row(-1)">添加</div>
              </td>
            </tr>
          </tbody>
        </table>
        <div style="height: 120px"></div>
      </div>
    </div>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        layer_list: null,
        setting_data: null,
        choosed_mcid: null,
        choosed_scid: null,
        choosed_rowid: null
      }
    },
    created() {
      window.naming_setting = this
      this.refresh_data()
    },
    computed: {
      choosed_mc() {
        if (this.choosed_mcid) {
          for(var i = 0; i < this.setting_data.length; i++){
            if (this.setting_data[i].id == this.choosed_mcid){
              return this.setting_data[i]
            }
          }
        }
        return null
      },
      choosed_sc() {
        if (this.choosed_scid) {
          for(var i = 0; i < this.sc_arr.length; i++){
            if (this.sc_arr[i].id == this.choosed_scid){
              return this.sc_arr[i]
            }
          }
        }
        return null
      },
      sc_arr() {
        if (this.choosed_mc && this.choosed_mc.c_arr) {
          return this.choosed_mc.c_arr
        }
        return []
      },
      current_category() {
        return this.choosed_sc ? this.choosed_sc : this.choosed_mc
      },
      data_arr() {
        return this.current_category ? this.current_category.d_arr : []
      }
    },
    methods: {
      choose_mc(mc) {
        if (this.choosed_mcid != mc.id) {
          this.choosed_mcid = mc.id
          this.choosed_rowid = null
        }
        this.choosed_scid = null
      },
      choose_sc(sc) {
        if (this.choosed_scid != sc.id) {
          this.choosed_scid = sc.id
          this.choosed_rowid = null
        }
      },
      add_category(type) {
        if (type == 'mc') {
          udoi('ns_category', 'add', {}, () => {
            this.refresh_setting_data()
          })
        }
        else if (this.choosed_mc) {
          udoi('ns_category', 'add', {parent_id: this.choosed_mc.id}, () => {
            this.refresh_setting_data()
          })
        }
      },
      move_choosed_category(type, action){
        if (type == 'mc' && this.choosed_mc) {
          udoi('ns_category', action, {id: this.choosed_mc.id}, () => {
            this.refresh_setting_data()
          })
        }
        if (type == 'sc' && this.choosed_sc) {
          var params = {parent_id: this.choosed_mc.id, id: this.choosed_sc.id}
          udoi('ns_category', action, params, () => {
            this.refresh_setting_data()
          })
        }
      },
      change_cname(type, category) {
        var params = {id: category.id, key: 'name', value: category.name}
        if (type == 'sc') { params.parent_id = this.choosed_mc.id }
        udoi('ns_category', 'change_value', params)
      },
      remove_category(type, category){
        if (type == 'mc') {
          var r = confirm("是否删除该大类？");
          if (r==false) { return }
        }
        var params = {id: category.id}
        if (type == 'sc') { params.parent_id = this.choosed_mc.id }
        udoi('ns_category', 'remove', params, () => {
          if (this.choosed_mcid == category.id) { this.choosed_mcid = null }
          if (this.choosed_scid == category.id) { this.choosed_scid = null }
          this.refresh_setting_data()
        })
      },
      add_row(index) {
        if (this.current_category == null) { return }
        var insert_index = index + 1
        var params = {index: insert_index, category_id: this.current_category.id}
        udoi('ns_data', 'add_by_index', params, () => {
          this.refresh_setting_data()
        })
      },
      move_row(row, action){
        if (this.current_category == null) { return }
        var params = {category_id: this.current_category.id, id: row.id}
        udoi('ns_data', action, params, () => {
          this.refresh_setting_data()
        })
      },
      change_row_attr(row, attr) {
        var params = {id: row.id, key: attr, value: row[attr]}
        params.category_id = this.current_category.id
        udoi('ns_data', 'change_value', params)
      },
      remove_row(row){
        var params = {category_id: this.current_category.id, id: row.id}
        udoi('ns_data', 'remove', params, () => {
          this.refresh_setting_data()
        })
      },
      import_data() {
        udoi('naming_setting', 'import', {}, () => { this.refresh_data() })
      },
      export_data() {
        udoi('naming_setting', 'export')
      },
      init_data() {
        udoi('naming_setting', 'init', {}, () => { this.refresh_data() })
      },
      refresh_data() {
        this.choosed_mcid = null
        this.choosed_scid = null
        this.choosed_rowid = null
        udoi('layer', 'data', {}, (data) => {
          this.layer_list = data
          this.refresh_setting_data()
        })
      },
      refresh_setting_data() {
        udoi('naming_setting', 'data', {}, (data) => {
          this.setting_data = data
          this.$nextTick(() => { cal_and_set_css() })
        })
      },
    }
  }
</script>

<style scoped>
  .left_bar{
    width: 370px;
    height: 90%;
    background-color: #f2f2f2;
    color: #333;
    position: absolute;
    z-index: 10;
    padding-bottom: 90px;
  }
  .right_bar{
    padding-left: 380px;
    padding-top: 10px;
    padding-bottom: 10px;
    height: 90%;
    box-sizing: border-box;
    position: absolute;
    left: 0;
    right: 0;
    overflow-x: hidden;
    overflow-y: auto;
    background-color: rgb(240, 240, 240);
  }
  .mc_list{
    width: 180px;
    position: absolute;
    z-index: 15;
  }
  .sc_list{
    width: 370px;
    padding-left: 180px;
    position: absolute;
    z-index: 10;
  }
  .list-group a{
    cursor: pointer;
  }
  .top_box{
    height: 40px;
    padding-left: 10px;
    padding-top: 5px;
    padding-bottom: 8px;
    background-color: rgb(198, 198, 198);
  }
  .btn_box{
    padding-top: 2px;
    padding-bottom: 4px;
    border-bottom: 1px solid #ddd;
  }
  .add_btn{
    padding-top: 3px;
    padding-bottom: 3px;
    margin-top: 5px;
    margin-bottom: 5px;
    margin-right: 3px;
    margin-left: 15px;
  }
  .sort_btn{
    margin-top: 5px;
    margin-bottom: 5px;
    padding-top: 3px;
    padding-bottom: 3px;
    padding-left: 8px;
    padding-right: 8px;
  }
  .top_btn{
    float: right;
    padding-top: 2px;
    padding-bottom: 2px;
    padding-left: 5px;
    padding-right: 5px;
    margin-right: 10px;
    margin-top: -1px;
  }
  .cname_input{
    width: 115px;
    margin-top: 3px;
  }
  .name_input{
    width: 135px;
    margin-top: 3px;
  }
  .attr_row{
    padding-top: 2px;
  }
  .option_box{
    position: relative;
    margin-left: 10px;
    margin-bottom: 3px;
    background-color: white;
  }
  .option_box:hover{
    background-color: rgb(234, 242, 255);
  }
  .option_box.active{
    background-color: rgb(255, 228, 141);
  }
  .option_line{
    height: 40px;
    margin-left: 10px;
    padding-top: 5px;
    cursor: default;
  }
  .option_line:hover .destroy {
    display: block;
  }
  .option_box.active .option_line .destroy{
    display: block;
  }
  .destroy{
    display: none;
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    width: 26px;
    height: 40px;
    margin: auto 0;
    font-size: 30px;
    color: #cc9a9a;
    margin-bottom: 3px;
    cursor: pointer;
  }
  .destroy:hover {
    color: #af5b5e;
  }
  .destroy:after {
    content: '×';
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
