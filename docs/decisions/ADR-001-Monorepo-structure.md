# Platform ADR: Monorepo Structure

## Status: Accepted

## Context
The project is structured as a monorepo, where both the product and platform codebases are housed within a single repository. This decision was made to facilitate easier code sharing, consistent tooling, and streamlined development workflows across the entire project.    

## Decision
We have decided to adopt a monorepo structure for our project, with the following directory layout: 

```
root/
├── product/
│   ├── src/
│   ├── tests/
│   └── ... (other product-related files)       
├── platform/
│   ├── src/    
│   ├── tests/
│   └── ... (other platform-related files)
├── docs/
├── .github/
├── .vscode/
├── scripts/
├── package.json
├── tsconfig.json
└── ... (other root-level files)    
```     

## Consequences
- **Code Sharing**: The monorepo structure allows for easy sharing of code, libraries, and utilities between the product and platform teams, reducing duplication and improving maintainability.  
- **Consistent Tooling**: With a single repository, we can enforce consistent tooling, configurations, and development practices across both teams, leading to improved collaboration and efficiency.  
- **Streamlined Development**: Developers can work on both the product and platform codebases without needing to switch repositories, enabling faster development cycles and easier cross-team collaboration.  
- **Complexity Management**: While the monorepo structure offers many benefits, it also introduces some complexity in terms of repository management, build processes, and deployment strategies. We will need to implement appropriate tooling and processes to manage this complexity effectively.    

