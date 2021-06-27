The BadgeTokenFactory contract provides basic structures, functions & modifiers that allows to manage BadgeToken as ERC721 token.

# Functions:
- [`constructor(address _badgeDefinitionFactoryAddress)`](#BadgeTokenFactory-constructor-address-)
- [`createBadgeDefinition(uint256 _badgeDefinitionId)`](#BadgeTokenFactory-createBadgeDefinition-uint256-)
- [`doesOwnBadgeFromGivenDefinition(address _owner, uint256 _badgeDefinitionId)`](#BadgeTokenFactory-doesOwnBadgeFromGivenDefinition-address-uint256-)

# Events:
- [`NewBadgeToken(uint256 _badgeTokenId, address _originalOwner)`](#BadgeTokenFactory-NewBadgeToken-uint256-address-)

# Function `constructor(address _badgeDefinitionFactoryAddress)` {#BadgeTokenFactory-constructor-address-}
See {ERC721-constructor}.

## Parameters:
- `_badgeDefinitionFactoryAddress`: The Ethereum address of the BadgeDefinitionFactory contract allowing to manage BadgeDefinition.
# Function `createBadgeDefinition(uint256 _badgeDefinitionId) → uint256 _badgeTokenId` {#BadgeTokenFactory-createBadgeDefinition-uint256-}
Creates & store a BadgeToken.

## Parameters:
- `_badgeDefinitionId`: The ID of BadgeDefinition associated to this BadgeToken.

## Return Values:
- _badgeTokenId The ID of the new BadgeToken.
# Function `doesOwnBadgeFromGivenDefinition(address _owner, uint256 _badgeDefinitionId) → bool _evaluationResult` {#BadgeTokenFactory-doesOwnBadgeFromGivenDefinition-address-uint256-}
Check if the conditions to mint the badge are met.

## Parameters:
- `_owner`: The Ethereum address of the user.

- `_badgeDefinitionId`: The ID of BadgeDefinition.

## Return Values:
- _evaluationResult The result of the test.

# Event `NewBadgeToken(uint256 _badgeTokenId, address _originalOwner)` {#BadgeTokenFactory-NewBadgeToken-uint256-address-}
Event emitted after a BadgeToken minting.

## Parameters:
- `_badgeTokenId`: The ID of the BadgeToken.

- `_originalOwner`: The Ethereum address of the user that has minted the token.
