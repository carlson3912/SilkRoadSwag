Visit silkroadswag.com for more info: https://docs.google.com/document/d/1gQH0Jc9Q1HRx5vNDJDUhI6_o6x_kmEMCmwhMTXu0GSg/edit
Silk Road Swag DAO Whitepaper


Introduction to DAOs
The critical feature of digital currencies is that they are decentralized. This means they are not controlled by a single institution like a government or central bank, but instead are divided among a variety of computers, networks, and nodes. Can this concept of decentralization apply to businesses as well? Can we build a business that not only takes advantage of the blockchain to facilitate transactions, but also uses it to control company ownership and operations in a completely trustless manner? Silk Road Swag (SRS), a trailblazer in the industry, is a clothing designer and manufacturer built on top of the Polygon blockchain that accomplishes just that. Internet users from anywhere in the world are able to join the community by acquiring SILK token, giving them partial ownership of SRS and allowing them to make business decisions for the organization. 
Evolution of the Clothing Brand
Silk Road Swag is the world's first DAO clothing brand that delivers products in the real world and the metaverse. From designing the clothes, to marketing and manufacturing, everything is carried out in a completely decentralized manner. Blockchain technology is also used to control ownership of the brand. On top of receiving the clothing item in physical and NFT form, each customer receives SILK token as a part of their order. SILK functions as a share in the organization and it’s value appreciates as the DAO makes profit. Besides generating revenue for its holders, SILK token also governs the DAO itself and functions as a vote in the organization’s operations. This, what we call order token payback, revolutionizes the clothing industry because customers are now being rewarded for the work that they do. Clothing brands mainly grow through the exposure provided by its own customers as they wear (and talk about) the clothing in front of friends and family. It only makes sense that they are rewarded and incentivized to do this. Since SILK will also be used to vote for designs, our customers (and shareholders) will provide a unique insight for the brand into the clothing market. Who has a more valuable and constructive opinion on our clothing than the people who actually buy it? All in all, Silk Road Swag is a flat organization with no positions of power that allow designers, salespeople and manufacturers to collaborate through an established protocol. Anyone is able to join the effort and profit based on how much work they do and how well they do it.
Business Structure
Marketing/Sales
Anyone in the world can sell SRS products by building a website that interacts with our smart contracts. And since they spent effort creating the sale, their wallet automatically receives a designated percentage of the profits generated through their gateway. All they have to do is send enough MATIC and call the public buyItem function:

The salesperson has to provide the function with three parameters:
Item_id: used to determine which variety of the item is being ordered (ie size and maybe color). 
Marketer: address to send rewards to for creating the sale
Delivery_instructions: encrypted delivery address for product (see explanation of public/private key pair encryption)
This function first ensures that the sale is valid:
Ensures amount paid = cost of item
Checks that the item is for sale and is in stock
Then, it automatically sends the manufacturer, designer and salesperson their share of the sale. Finally, it delivers the profits to the DAO and emits a Sale message that includes the item_id and the encrypted delivery address.
The dropshipping industry is worth more than $150 billion, yet, quite absurdly, no stores have been able to effectively incorporate the phenomenon into their business model. As of now, dropshipping is mainly used to resell cheap Chinese products. Here is a table highlighting the advantages of this sales model from the DAO’s and the seller’s perspectives.
Advantages for SRS
Advantages for Salesperson
Allows the DAO to remain fully decentralized. Token holders don’t want to have to rely on a small group of people to create sales for the entire organization.
DAO avoids the risks associated with investing in marketing.
Anyone is able to sell products and the best salespeople will rise to the top.
No platform fees (Shopify has three tiers of monthly fees at $29, $79 and $299.)
Much smaller transaction fees (currently takes around 3% of sale for credit card processing). Polygon transactions cost less than 2 cents per transaction.
Dropshipping process is streamlined: they only need to focus on making the sale and not on finding products or picking price points.
Paid in crypto and not fiat


Sales rewards will naturally fluctuate between each product as demand for generating more sales and demand for higher profit margins compete to find an equilibrium.
Design
Anyone in the world with an internet connection can design clothes for SRS by submitting their proposal into the weekly competition. Once they create a design with instructions that meet the manufacturing requirements, they can publish their work on IPFS for free using Piñata. After the design is published, they can enter the competition through the public createSale function in the DAO’s smart contract. On top of including their designs CID (provided by Piñata), the following is also included in the submission:
How many items will be sold (limited collection?)
Sales prices
Designer royalty + crypto address to send funds
Manufacturer
Cost of manufacturing + crypto address to send funds
Marketing incentive

All of these variables are taken into account by voters, who choose the most compelling product for the business. If their design is appreciated and receives enough votes, it will move to production and the artist will receive their share of the profits (See product description for more on weekly competition).
Manufacturing and Delivery:
As mentioned above, the manufacturer is included in each vote, so it can change from product to product. This ensures that SRS remains a decentralized organization and isn’t reliant on a single party. As each order comes in, the manufacturer amount (also included in the vote) is automatically sent as a form of payment to the manufacturer. They then need to monitor Polygonscan for Sale events that are emitted after each sale. Once a sale is made and announced by the blockchain, the manufacturer decrypts the delivery address using their private key and delivers the product. Anyone can become a supplier for SRS but they will need to offer a competitive, reliable service in order to amass enough votes.
Example Product
The first product will probably be manufactured and delivered by Printful. Here is an example of the potential cost breakdown.

Sales Price
$30
Manufacturing and Delivery
$13.90
Gas Fees
$0.10
Marketing Incentive (15%)
$3.75
Artist Royalty (15%)
$3.75
Profit
$8.5


This is a pretty inefficient business model because items are ordered one at a time. This will change for subsequent products as pre-stocking the items becomes less risky as the DAO develops a history of selling products.

Tokenomics
Order Token Payback
If each item sold also comes with 1 SILK token, the value of SILK will appreciate like this (provided that 2000 SILK is given to the founders of SRS).

As show in this graph (8.5x/(2000+x)), the value of SILK will reach around $2.8 if 1000 items are sold at a $8.5 profit. The order token payback value will be included in design submissions and will likely decrease as the value of SILK increases. For example, this means that down the road each customer could potentially only earn 0.1 SILK or maybe none at all. This means that the value of SILK doesn’t need to follow this logarithmic pattern and can increase at varying rates decided by SILK holders.

It is important to note that the “value” mentioned above only represents profit made by the DAO and isn’t the true speculative value of the token that would be used for trading purposes..

Technical
SILK token is an ERC-20 token that exists on the Polygon Network. On top of having the standard token functionalities such as transfer and transferFrom, it will have a couple additional abilities. First the smart contract contains a burn function that burns the given amount of SILK in exchange for its share of the DAO treasury. For example, you can burn 10% of the total supply of SILK and receive 10% of the profits that the DAO has made. While not really intended to be used, this function is extremely important in ensuring that SILK has value and that it can be liquidated for MATIC. 


Next, the smart contract has a castVote function that serves as the voting mechanism. It transfers your tokens to the design that you are voting for but also keeps track of them so that you can retrieve them once the competition is over.



