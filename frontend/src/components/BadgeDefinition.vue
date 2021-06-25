<template>
    <v-row class="text-center" align="center" justify="center">
  <v-card
    elevation="15"
    style="margin:50px; min-height:450px; max-width:700px; border-radius: 20px;
    padding: 1.5rem;  border: 1px solid; color: white; font-weight: 500;
    opacity: 0.95;"
    class="pa-10"
  >

    <v-row>
      <h1 class="display-2 black--text ma-3">
        Badge Factory
      </h1>
      <br/>
      <v-spacer></v-spacer>

      <metamask-chip/>
      <p class="subheading font-weight-regular black--text ma-2">
        No-code NFT badge model issuing
      </p>
    </v-row>
        <template>
          <v-form
            ref="form"
            v-model="valid"
            lazy-validation
          >

            <v-row>
              <v-col cols="4">
                <v-subheader>Badge Name</v-subheader>
              </v-col>
              <v-col cols="6">
                <v-text-field
                  v-model="name"
                  :counter="10"
                  :rules="nameRules"
                  label="Badge Name"
                  required
                  outlined
                  shaped
                  class="mb-n6"
                ></v-text-field>
              </v-col>
            </v-row>

            <v-row>
              <v-col cols="4">
                <v-subheader>Description</v-subheader>
              </v-col>
              <v-col cols="8">
                  <v-textarea
                    label="Description"
                    auto-grow
                    outlined
                    rows="3"
                    row-height="25"
                    shaped
                  ></v-textarea>
              </v-col>
            </v-row>

            <v-divider/>

            <v-row>
                <v-select
                  v-model="protocol"
                  :items="protocols"
                  :rules="[v => !!v || 'Protocol is required']"
                  label="Protocol"
                  required
                  outlined
                  shaped
                  class="mt-5"
                  dense
                ></v-select>
                <v-spacer/>
                <v-select
                  v-model="indexer"
                  :items="indexers"
                  :rules="[v => !!v || 'Protocol is required']"
                  label="Indexer"
                  required
                  outlined
                  shaped
                  class="mt-5"
                  dense
                ></v-select>
            </v-row>

            <v-row>
              <v-select
                v-model="metric"
                :items="metrics"
                :rules="[v => !!v || 'Metric is required']"
                label="Metric"
                required
                outlined
                shaped
                dense
                style="max-width:150px;"
              ></v-select>
                <v-spacer/>
              <v-select
                v-model="operator"
                :items="operators"
                :rules="[v => !!v || 'Operator is required']"
                label="Operator"
                required
                outlined
                shaped
                dense
                style="max-width:150px;"
              ></v-select>
              <v-spacer/>
              <v-text-field
                v-model="value"
                :counter="10"
                label="Value"
                required
                outlined
                shaped
                dense
                style="max-width:100px;"
              ></v-text-field>
              <v-spacer/>
              <v-btn
                class="mx-3"
                fab
                dark
                color="indigo"
                @click="updateConditions"
              >
              <v-icon dark>
                mdi-plus
              </v-icon>
            </v-btn>
            <p class="black--text">
            {{ conditions }}
            </p>
            </v-row>
            
            <v-switch
              v-model="checkbox2"
              label="NFT transfer authorized"
              required
            ></v-switch>

            <v-btn
              :disabled="!valid"
              color="success"
              class="mr-4"
              @click="validate"
            >
              Validate
            </v-btn>
          </v-form>
        </template>
    <v-spacer></v-spacer>
  </v-card>
    </v-row>
</template>

<script>
  import MetamaskChip from './MetamaskChip.vue'

  export default {
    name: 'BadgeFactory',
    components: {
      MetamaskChip,
    },
    data: () => ({
      valid: true,
      value: '',
      protocol: '',
      metric: '',
      operator: '',
      conditions: '',
      nameRules: [
        v => !!v || 'Badge Name is required',
        v => (v && v.length <= 10) || 'Badge Name must be less than 10 characters',
      ],
      select: null,
      protocols: [
        'Uniswap',
        'Compound',
        'Aave',
      ],
      metrics: [
        'Number of swap',
        'Gas consumed'
      ],
      indexers: [
        'The Graph Protocol',
        'Covalent',
      ],
      operators: [
        '==',
        '=>',
        '<=',
      ],
      checkbox2: true,
    }),

    methods: {
      validate () {
        this.$refs.form.validate()
      },
      updateConditions () {
        this.conditions = " The badge will be claimable to users of " + this.protocol 
          + " who have a " + this.metric + " "+ this.operator+" "+ this.value
      }
    },
  }
</script>