"""
AgentID Python Client

Main client for interacting with the AgentID API.
"""

from typing import Dict, List, Optional, Any
import requests


class AgentID:
    """
    AgentID client for managing AI agent identities and reputation.
    
    Example:
        client = AgentID(api_key="your_key")
        agent = client.register(
            name="MyAgent",
            capabilities=["chat", "search"],
            description="A helpful AI assistant"
        )
    """
    
    def __init__(self, api_key: str, base_url: str = "https://agentid.dev/api"):
        """
        Initialize the AgentID client.
        
        Args:
            api_key: Your AgentID API key
            base_url: Base URL for the AgentID API (default: https://agentid.dev/api)
        """
        self.api_key = api_key
        self.base_url = base_url.rstrip('/')
        self.session = requests.Session()
        self.session.headers.update({
            'Authorization': f'Bearer {api_key}',
            'Content-Type': 'application/json'
        })
    
    def register(
        self, 
        name: str, 
        description: str,
        capabilities: Optional[List[str]] = None
    ) -> Dict[str, Any]:
        """
        Register a new AI agent.
        
        Args:
            name: Name of the agent
            description: Description of the agent's purpose
            capabilities: List of agent capabilities
            
        Returns:
            Dict containing the registered agent's details
        """
        payload = {
            'name': name,
            'description': description,
            'capabilities': capabilities or []
        }
        response = self.session.post(f'{self.base_url}/agents/register', json=payload)
        response.raise_for_status()
        return response.json()
    
    def verify(self, agent_id: str) -> Dict[str, Any]:
        """
        Verify an agent's identity.
        
        Args:
            agent_id: The ID of the agent to verify
            
        Returns:
            Dict containing verification details
        """
        response = self.session.post(f'{self.base_url}/agents/{agent_id}/verify')
        response.raise_for_status()
        return response.json()
    
    def get_agent(self, agent_id: str) -> Dict[str, Any]:
        """
        Get details about an agent.
        
        Args:
            agent_id: The ID of the agent
            
        Returns:
            Dict containing agent details
        """
        response = self.session.get(f'{self.base_url}/agents/{agent_id}')
        response.raise_for_status()
        return response.json()
    
    def log_action(
        self,
        agent_id: str,
        action_type: str,
        status: str,
        metadata: Optional[Dict[str, Any]] = None
    ) -> Dict[str, Any]:
        """
        Log an action performed by an agent (builds reputation).
        
        Args:
            agent_id: The ID of the agent
            action_type: Type of action performed
            status: Status of the action ('success', 'failure', 'pending')
            metadata: Additional metadata about the action
            
        Returns:
            Dict containing the logged action details
        """
        payload = {
            'action_type': action_type,
            'status': status,
            'metadata': metadata or {}
        }
        response = self.session.post(
            f'{self.base_url}/agents/{agent_id}/actions',
            json=payload
        )
        response.raise_for_status()
        return response.json()
    
    def get_reputation(self, agent_id: str) -> Dict[str, Any]:
        """
        Get the reputation score for an agent.
        
        Args:
            agent_id: The ID of the agent
            
        Returns:
            Dict containing reputation details
        """
        response = self.session.get(f'{self.base_url}/agents/{agent_id}/reputation')
        response.raise_for_status()
        return response.json()
