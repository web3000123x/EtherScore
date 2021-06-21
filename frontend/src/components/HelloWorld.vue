<template>
  <v-container>
     <section>
        <v-parallax src="@/assets/paralax_white.jpg" height="500">
          <v-layout
            column
            align-center
            justify-center
            class="white--text"
          >
            <img
              src="@/assets/etherscore_black_transparent.svg"
              class="my-3"
              height="200"
            />
            <h1 class="black--text mb-2 display-1 text-center">EtherScore</h1>
            <div class="black--text subheading mb-4 text-center">NFTs based on Ethereum transaction history</div>
            <v-btn
              class="mt-12"
              dark
              large
              href="/badges"
            >
              Claim your NFTs
            </v-btn>
          </v-layout>
        </v-parallax>
      </section>

      <section>
        <v-layout
          column
          wrap
          class="my-12"
          align-center
        >
          <v-flex xs12 sm4 class="my-4">
            <div class="text-center">
              <h2 class="headline">What is EtherScore ?</h2>
              <span class="subheading">
                A protocol enabling Dapps to better identify and reward their users
              </span>
            </div>
          </v-flex>
          <v-flex xs12>
            <v-container grid-list-xl>
              <v-layout row wrap align-center>
                <v-flex xs12 md4>
                  <v-card flat class="transparent">
                    <v-card-text class="text-center">
                      <v-icon x-large class="blue--text text--lighten-2">mdi-decagram</v-icon>
                    </v-card-text>
                    <v-card-title primary-title class="layout justify-center">
                      <div class="headline">NFTs Badges</div>
                    </v-card-title>
                    <v-card-text>
                      Protocols can issue EtherScore badges to distribute to their users. <br/>
                      On-Chain verification of badge's conditions through Oracles. <br/>
                      Based on The Graph Protocol indexed data.
                    </v-card-text>
                  </v-card>
                </v-flex>
                <v-flex xs12 md4>
                  <v-card flat class="transparent">
                    <v-card-text class="text-center">
                      <v-icon x-large class="blue--text text--lighten-2">mdi-account-multiple-check</v-icon>
                    </v-card-text>
                    <v-card-title primary-title class="layout justify-center">
                      <div class="headline text-center">Community curation</div>
                    </v-card-title>
                    <v-card-text>
                      Reliable protocol's users are identified. <br/>
                      Protocols know their community. <br/>
                      More trust
                    </v-card-text>
                  </v-card>
                </v-flex>
                <v-flex xs12 md4>
                  <v-card flat class="transparent">
                    <v-card-text class="text-center">
                      <v-icon x-large class="blue--text text--lighten-2">mdi-gift-outline</v-icon>
                    </v-card-text>
                    <v-card-title primary-title class="layout justify-center">
                      <div class="headline text-center">Incentives</div>
                    </v-card-title>
                    <v-card-text>
                      More APYs <br/>
                      More fair airdrops <br/>
                      Less fees on partner's protocols
                    </v-card-text>
                  </v-card>
                </v-flex>
              </v-layout>
            </v-container>
          </v-flex>
        </v-layout>
      </section>

      <section>
        <v-parallax src="@/assets/paralax_white.jpg" height="380">
          <v-layout column align-center justify-center>
            <div class="headline black--text mb-4 text-center">Curated Vaults</div>
            <em class="black--text"> Get better staking profits if you are a reliable user</em>
            <v-btn
              class="mt-12"
              dark
              large
              href="/vaults"
            >
              Go To Vaults
            </v-btn>
          </v-layout>
        </v-parallax>
      </section>
    <section>
        <v-container grid-list-xl>
          <v-layout row wrap justify-center class="my-12">
            <v-flex xs12 sm4>
              <v-card flat class="transparent">
                <v-card-title primary-title class="layout justify-center">
                  <div class="headline">Company info</div>
                </v-card-title>
                <v-card-text>
                  EtherScore is a protocol based on Ethereum enabling Dapps to better identify their reliable
                   users by distributing them NFTs. These NFTs can then be used as conditions to access
                   specific smart contracts, airdrops, or even more DAO voting power and many other incentives.
                   EtherScore uses The Graph Protocol and Chainlink to execute all process on-chain.
                   
                </v-card-text>
              </v-card>
            </v-flex>
            <v-flex xs12 sm5 offset-sm1>
              <v-card flat class="transparent">
                <v-card-title primary-title class="layout justify-center">
                  <div class="headline">Contact us</div>
                </v-card-title>
                <v-card-text>
                  Feel free to contact us : 
                </v-card-text>
                <v-list class="transparent">
                  <v-list-item>
                    <v-list-item-action>
                      <v-icon class="blue--text text--lighten-2">mdi-email</v-icon>
                    </v-list-item-action>
                    <v-list-item-content>
                      <v-list-item-title>etherscore@protonmail.com</v-list-item-title>
                    </v-list-item-content>
                  </v-list-item>
                </v-list>
              </v-card>
            </v-flex>
          </v-layout>
        </v-container>
      </section>
  </v-container>
</template>

<script>
  export default {
    name: 'HelloWorld',
  }
</script>
